function [timg,xdata,ydata] = rectify(img,H,varargin)
assert(all(size(H) == [3 3]));

cfg.scale = 'No';
cfg.transforms = {};

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

S = eye(3,3);

if strcmpi(cfg.scale,'Yes')
    S = calc_scale(img,H,cfg.transforms{:})
end

H = S*H;

T = make_composite(H,cfg.transforms{:});

timg = imtransform(img,T,leftover{:});

function S = calc_scale(img,H,varargin)
    T = make_composite(H,varargin{:});
    nx = size(img,2);
    ny = size(img,1);

    keyboard;
    
    border = [0.5    ny+0.5; ...
              0.5    0.5; ...
              nx+0.5 0.5];
    tborder = tformfwd(T,border);

    border = [border ones(3,1)]';
    tborder = [tborder ones(3,1)]';
    
    ss = LAF.calc_scale([border(:) tborder(:)]);
    s = sqrt(abs(ss(1)/ss(2)));
    
    S = [10*s 0 0;
         0 10*s 0;
         0 0 1];


function T = make_composite(H,varargin)
if isempty(varargin)
    T = maketform('projective',H');
else
    T = maketform('composite',varargin{:}, ...
                  maketform('projective',H'));
end
