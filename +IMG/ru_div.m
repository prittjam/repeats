%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [timg,T,trect] = ru_div(img,cc,q,varargin)
cfg = struct('dims', transpose([size(img,1) size(img,2)]), ...
             'border', []);

[cfg,varargin] = cmp_argparse(cfg,varargin{:});

T0 = CAM.make_ru_div_tform(cc,q);

nx = size(img,2);
ny = size(img,1);

if ~isempty(cfg.border)
    border = cfg.border;
else
    border = [0.5     0.5; ...
              nx-0.5  0.5; ...    
              nx-0.5  ny-0.5; ...
              0.5     ny-0.5];
end

if cfg.dims
    [T,S] = IMG.register_by_dims(img,T0,cfg.dims);
else
    T = T0;
    S = eye(3);
end
 
T = T0;
tbounds = tformfwd(T,border);

minx = min(tbounds(:,1));
maxx = max(tbounds(:,1));
miny = min(tbounds(:,2));
maxy = max(tbounds(:,2));

timg = imtransform(img,T,'bicubic', ...
                   'XYScale',1, ...
                   'XData',[minx maxx], ...
                   'YData',[miny maxy], ...
                   'Fill',transpose([255 255 255]));

if ~isempty(cfg.dims)
    timg = imresize(timg,[ny nx]);
end

trect = [minx maxx miny maxy];