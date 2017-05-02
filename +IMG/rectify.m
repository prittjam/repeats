function [timg] = rectify(img,H,varargin)
assert(all(size(H) == [3 3]));

cfg.align = 'Similarity';
cfg.rd_xform = maketform('affine',eye(3));
cfg.good_points = [];

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

nx = size(img,2);
ny = size(img,1);

border = [0.5    0.5; ...
          nx+0.5 0.5; ...    
          nx+0.5 ny+0.5; ...
          0.5    ny+0.5];

tborder = tformfwd(cfg.rd_xform,border);

minx = min(tborder(:,1));
maxx = max(tborder(:,1));
miny = min(tborder(:,2));
maxy = max(tborder(:,2));

pts = LINE.intersect_rect(H(3,:)',[minx maxx miny maxy]);
in = inpolygon(pts(1,:),pts(2,:),tborder(:,1),tborder(:,2));

if any(in)
    keyboard;
end

T0 = maketform('composite', ...
               maketform('projective',H'), ...
               cfg.rd_xform);

switch lower(cfg.align)
  case 'affinity'
    assert(~isempty(cfg.good_points), ...
           ['You cannot align the rectification without inliers!']);
    T = align_by_affinity(cfg.good_points,T0);
    
  case 'similarity'
    assert(~isempty(cfg.good_points), ...
           ['You cannot align the rectification without inliers!']);
    T = align_by_similarity(cfg.good_points,T0);
  
  case 'scale'
    T = align_by_scale(img,T0);
end

tbounds = tformfwd(T,border);

minx = min(tbounds(:,1));
maxx = max(tbounds(:,1));
miny = min(tbounds(:,2));
maxy = max(tbounds(:,2));

timg = imtransform(img,T,'XYScale',1, ...
                   'XData',[minx maxx], ...
                   'YData',[miny maxy], ...
                   leftover{:});

function T = align_by_similarity(u,T0)
    v = [tformfwd(T0,transpose(u(1:2,:))) ... 
         ones(size(u,2),1)];
    A = HG.pt2x2_to_Rt([transpose(v);u]);
    T = maketform('composite', ...
                  maketform('affine',transpose(A)), ...
                  T0);

function T = align_by_affinity(u,T0)
    v = [tformfwd(T0,transpose(u(1:2,:))) ... 
         ones(size(u,2),1)];
    A = HG.pt3x2_to_A([transpose(v);u]);
    T = maketform('composite', ...
                  maketform('affine',transpose(A)), ...
                  T0);

function T = align_by_scale(img,T0)
    nx = size(img,2);
    ny = size(img,1);

    border = [0.5    0.5; ...
              nx+0.5 0.5; ...    
              nx+0.5 ny+0.5; ...
              0.5    ny+0.5];
    tborder = tformfwd(T0,border);
    
    s1 = polyarea(border(:,1),border(:,2));
    s2 = polyarea(tborder(:,1),tborder(:,2));
    s3 = sqrt(s1/s2);

    S = [s3 0 0; 0 s3 0; 0 0 1];

    T = maketform('composite', ...
                  maketform('affine',S'), ...
                  T0);
