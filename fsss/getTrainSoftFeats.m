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

function [trainPatches, countsPerImage]= getTrainSoftFeats(dsetname, rsiftDict, colDict, gridSize, alpha, beta)
    if nargin<1, dsetname= 'parisculpt'; end
    if nargin<4, gridSize= 35; end
    if nargin<5, alpha= 10; end
    if nargin<6, beta= 20; end
    
    kRSift= size(rsiftDict,2);
    kCol= size(colDict,2);
    kPos= 10;
    
    isStanfordBg= (strcmp(dsetname, 'stbg')==1);
    useX= isStanfordBg;
    if useX
        kPos= 36; % 6x6
    end
    
    [fns, labelFns, numFns]= fnlist(dsetname);
    
    if strcmp(dsetname, 'parisculpt')
        numLabels= 3; % 4 labels where 0==ignore
    else
        numLabels= 8;
    end
    trainPatches= cell(numLabels, 1);
    currIndex= zeros(numLabels, 1);
    for iLabel= 1:numLabels
        % allocates numLabels times too much ram
%          trainPatches{iLabel}= zeros(kRSift+kCol+kPos, numFns*gridSize*gridSize, 'single');
        % instead increase the matrix when needed
        trainPatches{iLabel}= zeros(kRSift+kCol+kPos, 10*gridSize*gridSize, 'single');
    end
    countsPerImage= zeros(numFns, numLabels);
    
    tic
    for iIm= 1:numFns
        if iIm<5 || rem(iIm,20)==0
            relja_display('%d / %d [%d %d %d] %.2fs', iIm, numFns, currIndex(1), currIndex(2), currIndex(3), toc);
        end
        
        [softSegFeats, supports, h, w, origH, origW, frameinfo]= ...
            getSoftFeats(fns{iIm}, rsiftDict, colDict, dsetname, ...
            'alpha', alpha, 'beta', beta, 'gridSize', gridSize);
        
        % read ground truth
        label= convLabel(labelFns{iIm}, false, dsetname);
        if all(label(:)==0), continue; end
        % for parisculpt it is possible that we rescaled the image, so scale gt
        if ( h~=size(label,1) || w~=size(label,2) )
            label= imresize(label, [h, w], 'nearest');
        end
        
        % pixel positions
        [x,y]= meshgrid( ([1:w]'-1)/(w-1), ([1:h]'-1)/(h-1) );
        pos= [x(:), y(:)];
        
        stepH= floor(h/(gridSize+1));
        stepW= floor(w/(gridSize+1));
        [y,x]= meshgrid( [1:gridSize] * stepH, [1:gridSize] * stepW );
        inds= sub2ind( [h, w], y(:), x(:) );
        assert(length(inds)==size(softSegFeats,2));
        for iPoint=1:length(inds)
            qind= inds(iPoint);
            thisLabel= label(qind);
            if thisLabel==0, continue; end
            currIndex(thisLabel)= currIndex(thisLabel)+1;
            
            % check if the matrix is large enough
            if size(trainPatches{thisLabel}, 2) < currIndex(thisLabel)
                % increase by 50%
                trainPatches{thisLabel}= [trainPatches{thisLabel}, ...
                    zeros(size(trainPatches{thisLabel},1), ceil(size(trainPatches{thisLabel},2)/2)) ];
            end
            
            trainPatches{thisLabel}(:, currIndex(thisLabel))= softSegFeats(:,iPoint);
            countsPerImage(iIm, thisLabel)= countsPerImage(iIm, thisLabel)+1;
        end
        
    end
    for iLabel= 1:numLabels
        trainPatches{iLabel}= trainPatches{iLabel}(:,1:currIndex(iLabel));
    end
    
    outfn= ['output/train_', dsetname, '.mat'];
    vl_xmkdir( fileparts(outfn) );
    save( outfn, 'trainPatches', 'countsPerImage', 'alpha', 'beta', 'gridSize');
    
end
