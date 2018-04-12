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

function acc= test_stbg(modelFn, rsiftDict, colDict, testGridSize, lam)
    if nargin<3, testGridSize= 20; end
    if nargin<4, lam= 500; end
    
    q= load(modelFn);
    
    % hack for matlab
    model= q.finalModel;
    beta= q.beta;
    alpha= q.alpha;
    gridSize= q.gridSize;
    crossTrainImg= q.crossTrainImg;
    
    relja_display('model: %s', modelFn);
    relja_display('alpha: %.4f, beta: %.4f, gridSize(train): %.4f', alpha, beta, gridSize);
    
    dsetname= 'stbg';
    
    [fns, labelFns, numFns]= fnlist(dsetname);
    
    gridSize= testGridSize;
    numCorrect= [];
    numTotal= [];
    
    relja_display('alpha: %.4f, beta: %.4f, gridSize(test): %.4f, lam: %.2f', alpha, beta, gridSize, lam);
    
    tottime= 0;
    for iIm= 1:numFns
        if iIm<10 || rem(iIm,20)==0
            relja_display('%d / %d, acc= %.4f, %.2fs', iIm, numFns, sum(numCorrect)/sum(numTotal), tottime/(iIm-1));
        end
        
        % read ground truth
        label= convLabel(labelFns{iIm}, false, dsetname);
        if all(label(:)==0), continue; end
        
        
        % which random split?
        ifold= find(~crossTrainImg(iIm,:)); assert(numel(ifold)==1);
        
        % do the stuff
        tic;
        pixelLabels= ...
            inferLabels(fns{iIm}, rsiftDict, colDict, ...
            model{ifold}, 'stbg', ...
            false, ...
            'alpha', alpha, 'beta', beta, ...
            'gridSize', testGridSize, 'lam', lam, ...
            'confThr', -1);
        tottime= tottime+toc;
        
        % eval
        assert(numel(label)==numel(pixelLabels));
        notignore= label(:)>1e-6;
        numCorrect= [numCorrect, sum( label(notignore)==pixelLabels(notignore) )];
        numTotal= [numTotal, sum(notignore)];
        
    end

    acc= sum(numCorrect)/sum(numTotal);
    relja_display('final: acc= %.4f, %.2fs', acc, toc);
end
