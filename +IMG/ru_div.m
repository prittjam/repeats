function [timg,T,trect] = ru_div(img,q,varargin)
nx = size(img,2);
ny = size(img,1);

cfg = struct('cc', [(nx+0.5)/2 (ny+0.5)/2]');
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

border = [0.5    0.5; ...
          nx+0.5 0.5; ...
          nx+0.5 ny+0.5; ...
          0.5    ny+0.5];

T = CAM.make_ru_div_tform(cfg.cc,q);

tbounds = tformfwd(T,border);

minx = min(tbounds(:,1));
maxx = max(tbounds(:,1));
miny = min(tbounds(:,2));
maxy = max(tbounds(:,2));

timg = imtransform(img,T,'bicubic', ...
                   'XYScale',1, ...
                   'XData',[minx maxx], ...
                   'YData',[miny maxy], ...
                   leftover{:});

trect = [minx maxx miny maxy];
