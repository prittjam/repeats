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

function [softSegFeats, supports, h, w, origH, origW, frameinfo]= getSoftFeats(fn, rsiftDict, colDict, dsetname, varargin)
    global ts;
    if isempty(ts), initGlobal; end
    
    getPaths;
    
    isStanfordBg= (strcmp(dsetname, 'stbg')==1);
    
    opts= struct();
    if isStanfordBg
        opts.gridSize= 25;
        opts.alpha= 15;
        opts.beta= 30;
        opts.lam= inf;
        opts.confThr= -1;
    else
        opts.gridSize= 20;
        opts.alpha= 10;
        opts.beta= 20;
        opts.lam= 500;
        opts.confThr= 0.1;
    end
    opts= vl_argparse(opts, varargin);
%      opts
    
    kRSift= size(rsiftDict,2);
    kCol= size(colDict,2);
    kPos= 10;
    
    useX= isStanfordBg;
    if useX
        kPos= 36; % 6x6
    end
    
    if isStanfordBg
        numSoftRSift= 5;
    else
        numSoftRSift= 1;
    end
    
    removeFrame= ~(isStanfordBg || strcmp(dsetname, 'parisculpt'));
    
    if strcmp(dsetname, 'ox')
        if (strcmp(fn(1:9), 'oxc1_100k')==1) || (strcmp(fn(1:4), 'oxc1')==1)
            fn= [oxfordPath, fn];
        else
            fn= [oxfordPath, 'oxc1/', fn];
        end
    elseif strcmp(dsetname, 'stbg')
        if length(fn)<15
            fn= [stanfordBgPath, fn];
        end
    end
    
    % image
    t0= tic;
    [imRGB, origH, origW, frameinfo]= imreadResize(fn, removeFrame);
%      figure; imshow(imRGB); drawnow
    w= size(imRGB,2);
    h= size(imRGB,1);
    ts.loadim= [ts.loadim, toc(t0)];
    
    
    %-------------- soft seg
    
    if strcmp(dsetname, 'ox')
        l= strfind(fn, '/ox');
        softSegFn= [oxfordSoftSegPath, fn((l(end)+1):end), '.mat'];
    else
        [~, tempFn]= fileparts(fn);
        if strcmp(dsetname, 'parisculpt')
            softSegFn= [parissculptSoftSegPath, tempFn, '.mat'];
        else
            softSegFn= [stanfordBgSoftSegPath, tempFn, '.mat'];
        end
        clear tempFn;
    end
    
    t0= tic;
    if ~exist(softSegFn)
        emb= softSegs(imRGB);
        vl_xmkdir( fileparts(softSegFn) );
        save(softSegFn, 'emb');
    else
        load(softSegFn, 'emb');
    end
    
    
    assert( h==size(emb,1) && w==size(emb,2) );
    embD= size(emb,3);
    embCol= reshape(emb, h*w, embD); clear emb;
    ts.softseg= [ts.softseg, toc(t0)];
    
    %-------------- features
    
    t0= tic;
    if isStanfordBg
        % images are small so reduce the sizes of dense SIFTs (default: 4,6,8,10)
        [imHSV, frames, rsifts]= allfeatures(imRGB, [4,6]);
    else
        [imHSV, frames, rsifts]= allfeatures(imRGB);
    end
    
    % filter rsifts in areas where there is a large variance in embedding
    inds= cell(5,1);
    inds{1}= sub2ind( [h,w], frames(2,:), frames(1,:) );
    inds{2}= sub2ind( [h,w], frames(2,:)-frames(4,:), frames(1,:) );
    inds{3}= sub2ind( [h,w], frames(2,:)+frames(4,:), frames(1,:) );
    inds{4}= sub2ind( [h,w], frames(2,:), frames(1,:)-frames(4,:) );
    inds{5}= sub2ind( [h,w], frames(2,:), frames(1,:)+frames(4,:) );
    embs= cell(5,1);
    embs{1}= embCol(inds{1},:);
    embs{2}= embCol(inds{2},:);
    embs{3}= embCol(inds{3},:);
    embs{4}= embCol(inds{4},:);
    embs{5}= embCol(inds{5},:);
    keep= true( size(frames,2), 1 );
    for i=1:4
        for j=(i+1):5
            keep= keep & ( sum( (embs{i}-embs{j}).^2, 2 ) < 0.1 );
        end
    end
    clear embs;
    rsifts= rsifts(:, keep);
    frames= frames(:, keep);
    clear keep;
    
    % compute rootsift/colour words
    [rsiftWords, rsiftDists]= yael_nn(rsiftDict, rsifts, numSoftRSift); clear rsifts;
    [colWords,~]= yael_nn(colDict, imHSV', 1); clear imHSV;
    
    % compute (x)y-position
    
    if useX
        kXY= round(sqrt(kPos));
        assert( kXY^2 == kPos );
        yHist= uniformQuant( relja_col( repmat( ([1:h]'-1)/(h-1), 1, w ) ), kXY );
        xHist= uniformQuant( relja_col( repmat( ([1:w]-1)/(w-1)', h, 1 ) ), kXY );
        posHist= (yHist-1)*kXY+xHist;
        clear xHist yHist kXY;
    else
        yHist= uniformQuant( relja_col( repmat( ([1:h]'-1)/(h-1), 1, w ) ), kPos );
        posHist= yHist;
        clear yHist;
    end
    
    % compute a (unnorm) hist for every pixel
    feats= zeros(h*w, kRSift+kCol+kPos, 'single');
    
    % colour
    feats( sub2ind(size(feats), [1:(h*w)]', kRSift+double(colWords')) )= 1;
    clear colWords;
    
    % position
    feats( sub2ind(size(feats), [1:(h*w)]', kRSift+kCol+posHist) )= 1;
    clear posHist;
    
    % dense rootsift:
    % slightly more complex for dense sift as multiple on same pixel
    centInd= sub2ind( [h,w], frames(2,:), frames(1,:) ); clear frames;
    
    % if numSoftRSift this just reduces to ones(size(rsiftWords))
    softweight= relja_l1normalize_col( exp( -rsiftDists/0.2 ) ); clear rsiftDists;
    feats= vl_binsum( feats, softweight, repmat(centInd,size(rsiftWords,1),1) + (double(rsiftWords)-1)*h*w );
    clear softweight rsiftWords centInd;
    
    feats= sparse(double(feats));
    ts.localfeat= [ts.localfeat, toc(t0)];
    
    
    %-------------- compute features for unaries (soft segments)
    % i.e. accumulate pixe-wise histograms using w(i,j) ('support')
    t0= tic;
    
    % all pixel positions
    [x,y]= meshgrid( ([1:w]'-1)/(w-1), ([1:h]'-1)/(h-1) );
    pixelPos= [x(:), y(:)]; clear x y;
    
    % soft segment positions
    stepH= floor(h/(opts.gridSize+1));
    stepW= floor(w/(opts.gridSize+1));
    [y,x]= meshgrid( [1:opts.gridSize] * stepH, [1:opts.gridSize] * stepW );
    
    inds= sub2ind( [h, w], y(:), x(:) ); clear x y;
    numSoftSegs= length(inds);
    supports= cell( numSoftSegs, 1);
    softSegFeats= zeros(size(feats,2), numSoftSegs);
    dsSs= vl_alldist2( embCol', embCol(inds, :)' );
    dsPs= vl_alldist2( pixelPos', pixelPos(inds, :)' );
    supports= exp(-opts.alpha*dsSs -opts.beta*dsPs);
    softSegFeats= feats'*supports;
    clear feats embCol dsSs dsPs pixelPos;
    
    % apply Hellinger feature transform to each histogram, normalize
    softSegFeats= [ ...
        sqrt(relja_l1normalize_col(softSegFeats(1:kRSift,:))); ...
        sqrt(relja_l1normalize_col(softSegFeats(kRSift+[1:kCol],:))); ...
        sqrt(relja_l1normalize_col(softSegFeats(kRSift+kCol+[1:kPos],:)))];
    ts.softfeat= [ts.softfeat, toc(t0)];
    
end
