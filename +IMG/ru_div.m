function [timg,T,trect] = ru_div(img,cc,q,varargin)
cfg = struct('extents', transpose([size(img,2),size(img,1)]), ...
             'bbox', []);

[cfg,varargin] = cmp_argparse(cfg,varargin{:});

T0 = CAM.make_ru_div_tform(cc,q);

nx = size(img,2);
ny = size(img,1);

if ~isempty(cfg.bbox)
    border = cfg.bbox;
else
    border = [0.5        0.5; ...
              (nx-1)+0.5 0.5; ...    
              (nx-1)+0.5 (ny-1)+0.5; ...
              0.5        (ny-1)+0.5];
end

if cfg.extents
    [T,S] = register_by_extent(img,T0,cfg.extents);
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

if ~isempty(cfg.extents)
    timg = imresize(timg,[ny nx]);
end

trect = [minx maxx miny maxy];

function [T,S] = register_by_extent(img,T0,extents)
    nx = size(img,2);
    ny = size(img,1);
   
    border0 = [0.5       0.5; ...
              (nx-1)+0.5 0.5; ...    
              (nx-1)+0.5 (ny-1)+0.5; ...
              0.5        (ny-1)+0.5];
    tborder0 = tformfwd(T0,border0);
    
    xextent = max(tborder0(:,1))-min(tborder0(:,1))+1;
    yextent = max(tborder0(:,2))-min(tborder0(:,2))+1;
    
    sx = abs(extents(1)/xextent);
    sy = abs(extents(2)/yextent);

    S = [sx  0 0;
          0 sy 0;
          0  0 1];
    
    T = maketform('composite', ...
                  maketform('affine',S'), ...
                  T0);