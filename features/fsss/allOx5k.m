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

setup;

trainDset= 'parisculpt';
dictFn= 'data/dicts_parisculpt.mat';

if ~exist(dictFn)
    relja_display('-- Compute RootSIFT + colour dictionaries');
    [rsiftDict, colDict]= compDict(trainDset);
    save(dictFn, 'rsiftDict', 'colDict');
else
    load(dictFn, 'rsiftDict', 'colDict');
end


alpha= 10;
beta= 20;
gridSize= 20;
lam= 500;
confThr= 0.1;



modelFn= 'data/model_parisculpt.mat';

if ~exist(modelFn)
    relja_display('-- Learn the SVM');
    
    [trainPatches, countsPerImage]= getTrainSoftFeats(trainDset, rsiftDict, colDict, gridSize, alpha, beta);
    
    [bestC, bestB, testAcc, crossTrainImg, finalModel]= svmCross(trainPatches, countsPerImage, rsiftDict, colDict, trainDset);
    
    save( modelFn, 'bestC', 'bestB', 'testAcc', 'crossTrainImg', 'finalModel', 'alpha', 'beta', 'gridSize');
else
    load(modelFn, 'finalModel');
end
model= finalModel;



doOx5k= true; % set to false to compute on the Oxford 100k distractor set

relja_display('-- Segmenting all test images');

if doOx5k
    testimages= textread('data/imagelist_oxc1_5k.txt', '%s');
else
    testimages= textread('data/imagelist_only_ox100k.txt', '%s');
end
testimages= sort(testimages);

initGlobal;

for iIm=1:length(testimages)
    if iIm<5 || rem(iIm,200)==1 || mod(log2(iIm),1)==0
        if iIm>1
            relja_display('%d / %d, %.2f', iIm, length(testimages), mean(ts.total));
            relja_display('%.2f (%.2f %.2f %.2f %.2f) %.2f %.2f | %.2f', ...
                mean(ts.feats), ...
                mean(ts.loadim), mean(ts.softseg), mean(ts.localfeat), mean(ts.softfeat), ...
                mean(ts.unaries), mean(ts.infer), mean(ts.total));
        else
            relja_display('%d / %d', iIm, length(testimages));
        end
    end
    
    if doOx5k
        fn= testimages{iIm}(6:end);
        outfn= ['output/hard/oxc1/', fn, '.png'];
        outfnConf= ['output/soft/oxc1/', fn, '.png'];
    else
        fn= testimages{iIm};
        outfn= ['output/hard/ox100k/', fn, '.png'];
        outfnConf= ['output/soft/ox100k/', fn, '.png'];
    end
    if exist(outfn) && exist(outfnConf)
        continue;
    end
    
    t0= tic;
    [pixelLabels, pixelLabelsConf, imout, imoutConf]= ...
        inferLabels(fn, rsiftDict, colDict, model, 'ox', ...
            true, ...
            'alpha', alpha, 'beta', beta, 'gridSize', gridSize, ...
            'lam', lam, 'confThr', confThr);
    ts.total= [ts.total, toc(t0)];
    
    
    vl_xmkdir( fileparts(outfn) );
    imwrite(imout, outfn);
    vl_xmkdir( fileparts(outfnConf) );
    imwrite(imoutConf, outfnConf);
end
