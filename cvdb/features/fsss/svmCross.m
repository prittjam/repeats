%
% Author:
% 
% Relja Arandjelovic (relja@robots.ox.ac.uk)
% Visual Geometry Group,
% Department of Engineering Science
% University of Oxford
% 
% Copyright 2014, all rights reserved.
% 

function [bestC, bestB, testAcc, crossTrainImg, finalModel]= svmCross(trainPatches, countsPerImage, rsiftDict, colDict, dsetname)
    % assumes trainPatches have been normalized already
    
    kRSift= size(rsiftDict,2);
    kCol= size(colDict,2);
    kY= size(trainPatches{1},1) - kRSift - kCol;
    
    numLabels= size(countsPerImage,2);
    temp_= sum(countsPerImage,1);
    
    allPatches= double(cat(2,trainPatches{:}));
    clear trainPatches;
    allLabels= [];
    for iLabel=1:numLabels
        allLabels= [allLabels; iLabel*ones(temp_(iLabel),1)];
    end
    clear temp_;
    
    nTrain= size(allPatches,2);
    kfold= 5;
    numFns= size(countsPerImage,1);
    
    
    % splits across images
    cumCountsPerImage= [zeros(1, numLabels); cumsum(countsPerImage,1)];
    
    rand('seed', 43);
    C= cvpartition(numFns, 'Kfold', kfold);
    crossTrainImg= false(numFns, kfold);
    for i=1:kfold
        crossTrainImg(:,i)= C.training(i);
    end
    clear C;
    
    crossTrain= false(nTrain, kfold);
    
    for ifold= 1:kfold
        for i= find(crossTrainImg(:,ifold)')
            for iLabel= 1:numLabels
                crossTrain( sum(cumCountsPerImage(end,[1:(iLabel-1)])) + [(cumCountsPerImage(i,iLabel)+1):cumCountsPerImage(i+1,iLabel)], ifold)= true;
            end
        end
    end
    
    
    
    % grid search for C
    
    bestAcc= [0 0];
    bestC= 1;
    bestConfMat= [];
    
    tic;
    relja_display('Searching for C');
    
    %for C= [0.001 0.005 0.01 0.02 0.05 0.1 0.5 1 10]
    for C= [0.005 0.01 0.02 0.05 0.1]
        relja_display('\n\tC= %.4f', C);
        
        accs= [];
        
        for ifold= 1:kfold
            model= train( ...
                allLabels(crossTrain(:,ifold)), ...
                sparse( allPatches(:,crossTrain(:,ifold))' ), ...
                sprintf('-q -s 3 -B 1 -c %.4f', C));
            
            [pred, accTrain, ~]= predict( ...
                allLabels(crossTrain(:,ifold)), ...
                sparse( allPatches(:,crossTrain(:,ifold))' ), model, '-q' );
            
            [pred, accTest, ~]= predict( ...
                allLabels(~crossTrain(:,ifold)), ...
                sparse( allPatches(:,~crossTrain(:,ifold))' ), model, '-q' );
            
            accs= [accs; accTrain(1), accTest(1)];
            relja_display('C= %.4f, ifold= %d, train: %.4f, test: %.4f', C, ifold, accTrain(1), accTest(1));
        end
        
        accTrain= mean(accs(:,1));
        accTest= mean(accs(:,2));
        relja_display('C= %.4f, train: %.4f, test: %.4f', C, accTrain, accTest);
        confMat= confusionmat(allLabels(~crossTrain(:,ifold)), pred);
        confMat= bsxfun(@rdivide,confMat,sum(confMat,2)) * 100;
        display(confMat);
    %      imagesc(confMat,[0,100]); colormap gray;
        
        if accTest>bestAcc(2)
            bestAcc= [accTrain, accTest];
            bestC= C;
            bestConfMat= confMat;
        end
    end
    relja_display('C= %.4f, train: %.4f, test: %.4f', bestC, bestAcc(1), bestAcc(2));



    % grid search for B

    bestB= 1;

    relja_display('Searching for B');

    for B= [-1 0.1 10] % already tried 1
        relja_display('\n\tB= %.4f', B);
        
        accs= [];
        
        for ifold= 1:kfold
            model= train( ...
                allLabels(crossTrain(:,ifold)), ...
                sparse( allPatches(:,crossTrain(:,ifold))' ), ...
                sprintf('-q -s 3 -B %.4f -c %.4f', B, bestC));
            
            [pred, accTrain, ~]= predict( ...
                allLabels(crossTrain(:,ifold)), ...
                sparse( allPatches(:,crossTrain(:,ifold))' ), model, '-q' );
            
            [pred, accTest, ~]= predict( ...
                allLabels(~crossTrain(:,ifold)), ...
                sparse( allPatches(:,~crossTrain(:,ifold))' ), model, '-q' );
            
            accs= [accs; accTrain(1), accTest(1)];
            relja_display('B= %.4f, ifold= %d, train: %.4f, test: %.4f', B, ifold, accTrain(1), accTest(1));
        end
        
        accTrain= mean(accs(:,1));
        accTest= mean(accs(:,2));
        relja_display('B= %.4f, train: %.4f, test: %.4f', B, accTrain, accTest);
        confMat= confusionmat(allLabels(~crossTrain(:,ifold)), pred);
        confMat= bsxfun(@rdivide,confMat,sum(confMat,2)) * 100;
        display(confMat);
    %      imagesc(confMat,[0,100]); colormap gray;
        
        if accTest>bestAcc(2)
            bestAcc= [accTrain, accTest];
            bestB= B;
            bestConfMat= confMat;
        end
    end
    toc
    relja_display('C= %.4f, B= %.4f, train: %.4f, test: %.4f', bestC, bestB, bestAcc(1), bestAcc(2));
    
    testAcc= bestAcc(2);
    
    
    
    
    
    % train final
    relja_display('Train final model(s)');
    
    if strcmp(dsetname, 'parisculpt')
        
        tic
        finalModel= train( allLabels, sparse( allPatches' ), ...
            sprintf('-q -s 3 -B %.4f -c %.4f', bestB, bestC));
        toc
        
        [pred, acc, ~]= predict( allLabels, sparse( allPatches' ), finalModel, '-q' );
        relja_display('\n\tfinal: B= %.4f, C= %.4f, all train: %.4f', bestB, bestC, acc(1));
        confMat= confusionmat(allLabels, pred);
        confMat= bsxfun(@rdivide,confMat,sum(confMat,2)) * 100;
        display(confMat);
%          imagesc(confMat,[0,100]); colormap gray;
        
    else
        
        accs= [];
        finalModel= cell(kfold,1);
        
        for ifold= 1:kfold
            finalModel{ifold}= train( ...
                allLabels(crossTrain(:,ifold)), ...
                sparse( allPatches(:,crossTrain(:,ifold))' ), ...
                sprintf('-q -s 3 -B %.4f -c %.4f', bestB, bestC));
            
            [pred, accTrain, ~]= predict( ...
                allLabels(crossTrain(:,ifold)), ...
                sparse( allPatches(:,crossTrain(:,ifold))' ), finalModel{ifold}, '-q' );
            
            [pred, accTest, ~]= predict( ...
                allLabels(~crossTrain(:,ifold)), ...
                sparse( allPatches(:,~crossTrain(:,ifold))' ), finalModel{ifold}, '-q' );
            
            accs= [accs; accTrain(1), accTest(1)];
            relja_display('C= %.4f, B= %.4f, ifold= %d, train: %.4f, test: %.4f', bestC, bestB, ifold, accTrain(1), accTest(1));
        end
        
    end

    
end
