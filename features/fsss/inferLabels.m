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

function [pixelLabels, pixelLabelsConf, imout, imoutConf]= inferLabels(fn, rsiftDict, colDict, model, dsetname, outputImage, varargin)
    global ts;
    
    isStanfordBg= (strcmp(dsetname, 'stbg')==1);
    if isStanfordBg
        opts.lam= inf;
        opts.confThr= -1;
    else
        opts.lam= 500;
        opts.confThr= 0.1;
    end
    opts.alpha= [];
    opts.beta= [];
    opts.gridSize= [];
    
    opts= vl_argparse(opts, varargin);
    
    kRSift= size(rsiftDict,2);
    kCol= size(colDict,2);
    kPos= 10;
    
    isForest= ismember('ClassNames', fieldnames(model));
    if isForest
        numLabels= length(model.ClassNames);
    else
        numLabels= model.nr_class;
    end
    
    useX= isStanfordBg;
    if useX
        kPos= 36; % 6x6
    end
    
    % argument mess
    vargin_temp= {};
    for fieldName= fieldnames(opts)'
        val= opts.(fieldName{1});
        if isempty(val), continue; end
        vargin_temp= [vargin_temp, fieldName{1}, val ];
    end
    
    %-------------- compute features for all soft segments
    t0= tic;
    [softSegFeats, supports, h, w, origH, origW, frameinfo]= ...
        getSoftFeats(fn, rsiftDict, colDict, dsetname, vargin_temp{:});
    clear vargin_temp val;
    
    numSoftSegs= size(softSegFeats,2);
    ts.feats= [ts.feats, toc(t0)];
    
    
    %-------------- compute unaries
    t0= tic;
    if isForest
        [~, unary]= model.predict(softSegFeats');
        [~, pred]= max(unary,[],2);
    else
        [pred, ~, unary]= predict(zeros([numSoftSegs,1]), sparse(double(softSegFeats)'), model, '-q');
    end
    clear softSegFeats;
    ts.unaries= [ts.unaries, toc(t0)];
    
    
    %-------------- inference on the graphical model
    t0= tic;
    
    % init
    segmentLabels= pred;
    clear pred;

    prevPixelLabels= -ones(w*h,1);
    prevSegmentLabels= -ones(numSoftSegs,1);
    
    % alternate the two steps
    for iterFilt= 1:10 % limit to 10 iterations but always finishes earlier..
        
        if all(segmentLabels(:)==segmentLabels(1))
            % no more iteration (if any was done) as all labels are the same
            pixelLabels= segmentLabels(1) * ones(w*h, 1);
            % make a fake negE1 (actual values are not important, just make the solution the best)
            negE1= zeros(w*h,3); negE1(:, segmentLabels(1))= 1;
            break;
        end
        
        %  figure; imshow(labelImage(segmentLabels, gridSize, gridSize, w, h));
        
        %%% step 1: fix L_i find l_j
        
        if iterFilt==1
            
            % can do this for all iterations, but faster if we do diff
            negE1= zeros(w*h,numLabels);
            for iPoint=1:numSoftSegs
                negE1(:,segmentLabels(iPoint))= negE1(:,segmentLabels(iPoint)) + supports(:,iPoint);
            end
        
        else
            
            % in practice, many segments stay the same, so silly to do the relatively expensive step for all segments above
            % instead - track what changed and update the difference
            changedLabels= find(segmentLabels'~=prevSegmentLabels');
            assert( size(changedLabels,1) <=1 );
            for iPoint= changedLabels
                negE1(:,prevSegmentLabels(iPoint))= negE1(:,prevSegmentLabels(iPoint)) - supports(:,iPoint);
                negE1(:,segmentLabels(iPoint))= negE1(:,segmentLabels(iPoint)) + supports(:,iPoint);
            end
            
        end
        
        prevSegmentLabels= segmentLabels;
        
        %  figure; imshow(reshape( relja_l1normalize_row(negE1),[h,w,3]));
        [~,pixelLabels]= max(negE1,[],2);
        %  figure; imshow(labelImage(pixelLabels,w,h));
        
        
        
        if isinf(opts.lam)
            % unaries dominate whatever step 1 did, so finish
            break;
        end
        if (all(pixelLabels(:)==prevPixelLabels(:))), break; end % converged
        
        
        
        %%% step 2: fix l_j find L_i
        
        if iterFilt==1
            
            % can do this for all iterations, but faster if we do diff
            negE2= zeros(numSoftSegs, numLabels);
            for iPoint=1:numSoftSegs
                negE2(iPoint, :)= vl_binsum( zeros(1,numLabels), supports(:,iPoint), pixelLabels );
                % % equivalent to the code below, but faster
                % for iLabel=1:numLabels
                %     negE2(iPoint, iLabel)= sum(supports(pixelLabels==iLabel,iPoint));
                % end
            end
        else
            
            % in practice, many pixels stay the same, so silly to do the relatively expensive step for all pixels above
            % instead - track what changed and update the difference
            changedPixels= find(pixelLabels~=prevPixelLabels);
            
            for iPoint=1:numSoftSegs
                supportChanged= supports(changedPixels,iPoint);
                for iLabel=1:numLabels
                    negE2(iPoint, iLabel)= negE2(iPoint, iLabel) ...
                        - sum( supportChanged(prevPixelLabels(changedPixels)==iLabel) ) ...
                        + sum( supportChanged(pixelLabels(changedPixels)==iLabel) );
                end
            end
            
        end
        
        prevPixelLabels= pixelLabels;
        
        %  figure; imshow( permute(imresize( reshape( relja_l1normalize_row(negE2+opts.lam*unary), [gridSize, gridSize, 3]), [w, h], 'nearest' ), [2,1,3]) );
        [~,segmentLabels]= max(negE2 + opts.lam*unary,[],2);
        %  figure; imshow(labelImage(segmentLabels, gridSize, gridSize, w, h));
%          clear negE2; % don't delete because we are doing incremental stuff
        
        if (all(segmentLabels(:)==prevSegmentLabels(:))), break; end % converged
    end
    clear unary negE2 prevPixelLabels segmentLabels prevSegmentLabels supports;
    
    %  figure; imshow(labelImage(pixelLabels(:),w,h));
    pixelLabels= reshape(pixelLabels, [h,w]);
    pixelLabels= imresize(pixelLabels, [origH, origW], 'nearest');

    % uncertainty in segmentation
    
    if opts.confThr<0
        notconf= false(h*w,1);
        clear negE1;
    else
        e1= sort( relja_l1normalize_row(negE1), 2, 'descend' ); clear negE1;
        e1= reshape( imresize( reshape(e1,[h,w,numLabels]), [origH, origW], 'nearest'), [origH*origW, numLabels] );
        notconf= opts.confThr*e1(:,1)<e1(:,2); clear e1;
    end
    
    % filter holes
    if ~isStanfordBg
        pixelLabels= filterHoles(pixelLabels);
    end
    
    % fill in uncertain regions
    pixelLabelsConf= pixelLabels;
    pixelLabelsConf(notconf)= 0;
    
    % add frames back if it exists
    pixelLabels= readdFrame(pixelLabels, frameinfo);
    pixelLabelsConf= readdFrame(pixelLabelsConf, frameinfo);
    
    ts.infer= [ts.infer, toc(t0)];
    
    origW= frameinfo.origW; origH= frameinfo.origH; clear frameinfo;
    
    
    if outputImage
        imout= labelImage( pixelLabels(:), origW, origH, origW, origH, isStanfordBg );
        %  figure; imshow(imresize(imout, [h,w], 'nearest'));

        imoutConf= labelImage( pixelLabelsConf(:), origW, origH, origW, origH, isStanfordBg );
        %  figure; imshow(imresize(pixelLabelsConf, [h,w], 'nearest'));
    end
    
end
