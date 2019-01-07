%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [timg,trect,T,A] = rectify(img,H,varargin)
    assert(all(size(H) == [3 3]));

    [ny,nx,~] = size(img);

    cfg.border = [ 0.5    0.5; ...
                   nx-0.5 0.5; ...
                   nx-0.5 ny-0.5; ...
                   0.5 ny-0.5 ];
    cfg.dims = [];
    cfg.cspond = [];
    cfg.registration = 'Similarity';
    cfg.ru_xform = maketform('affine',eye(3));
    cfg.fill = [255 255 255]';
    
    [cfg,leftover] = cmp_argparse(cfg,varargin{:});
    
    leftover = { 'Fill', cfg.fill, ...
                 leftover{:} };
    
    if isempty(cfg.ru_xform)
        T0 = maketform('projective',H');
    else
        T0 = maketform('composite', ...
                       maketform('projective',H'), ...
                       cfg.ru_xform);
    end
    
    switch lower(cfg.registration)
      case 'affinity'
        assert(~isempty(cfg.cspond), ...
               ['You cannot register the rectification without inliers!']);
        [T,A] = register_by_affinity(cfg.cspond,T0);
      case 'similarity'
        assert(~isempty(cfg.cspond), ...
               ['You cannot register the rectification without inliers!']);
        [T,A] = register_by_similarity(cfg.cspond,T0);
      case 'scale'
        [T,A] = register_by_scale(img,T0,cfg.border);
      case 'none'
        T = T0;
        A = eye(3);
      otherwise
        error('No registration method specified'); 
    end

    if ~isempty(cfg.dims)
        [T,A2] = IMG.register_by_dims(img,T,cfg.border,cfg.dims);
        A = A2*A;
    end
    
    outbounds = tformfwd(T,cfg.border);

    timg = imtransform(img,T,'bicubic', ...
                       'XData', [min(outbounds(:,1)) max(outbounds(:,1))], ...
                       'YData', [min(outbounds(:,2)) max(outbounds(:,2))], ...
                       'XYScale',1, ...
                       leftover{:}); 
    
    trect = [min(outbounds(:,1)) min(outbounds(:,2)) ...
             max(outbounds(:,1)) max(outbounds(:,2))];
                                                     
    
function [T,A] = register_by_similarity(u,T0)
    v = [tformfwd(T0,transpose(u(1:2,:))) ... 
         ones(size(u,2),1)];
    A = HG.pt2x2_to_sRt([transpose(v);u]);
    T = maketform('composite', ...
                  maketform('affine',transpose(A)), ...
                  T0);

function [T,A] = register_by_affinity(u,T0)
    v = [tformfwd(T0,transpose(u(1:2,:))) ... 
         ones(size(u,2),1)];
    A = HG.pt3x2_to_A([transpose(v);u]);
    T = maketform('composite', ...
                  maketform('affine',transpose(A)), ...
                  T0);

function [T,S] = register_by_scale(img,T0,roi)
    nx = size(img,2);
    ny = size(img,1);

    troi = tformfwd(T0,roi);
    
    s1 = polyarea(roi(:,1),roi(:,2));
    s2 = polyarea(troi(:,1),troi(:,2));
    s3 = sqrt(s2/s1);

    S = [s3 0 0; 0 s3 0; 0 0 1];

    T = maketform('composite', ...
                  maketform('affine',S'), ...
                  T0);

