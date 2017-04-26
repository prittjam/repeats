function [timg] = rectify(img,H,varargin)
assert(all(size(H) == [3 3]));

cfg.align = 'Similarity';
cfg.good_points = [];
cfg.transforms = {};
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

S = eye(3,3);

switch lower(cfg.align)
  case 'similarity'
    assert(~isempty(cfg.good_points), ...
           ['You cannot align the rectification without inliers!']);
    S = calc_align(cfg.good_points,H,cfg.transforms{:});
  case 'scale'
    S = calc_scale(img,H,cfg.transforms{:});
end

H1 = S*H;

T = make_composite(H1,cfg.transforms{:});

timg = imtransform(img,T,'XYScale',1,leftover{:});

function S = calc_align(u,H,varargin)
v = PT.renormI(H*u);
S = HG.pt2x2_to_sRt([v;u]);

function S = calc_scale(img,H,varargin)
    T = make_composite(H,varargin{:});
    nx = size(img,2);
    ny = size(img,1);
    
    border = [0.5    ny+0.5; ...
              0.5    0.5; ...
              nx+0.5 0.5];
    tborder = tformfwd(T,border);

    border = [border ones(3,1)]';
    tborder = [tborder ones(3,1)]';
    
    ss = LAF.calc_scale([border(:) tborder(:)]);
    ss2 = sqrt(abs(ss(1)/ss(2)));
    S = [ss2 0 0; 0 ss2 0; 0 0 1];
    
function T = make_composite(H,varargin)
if isempty(varargin)
    T = maketform('projective',H');
else
    T = maketform('composite',maketform('projective',H'),varargin{:});
end
