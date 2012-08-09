function timg = hg_rectify_img(img,T)
nx = size(img,2);
ny = size(img,1);
border = [0.5    0.5; ...
          nx+0.5 0.5; ...
          nx+0.5 ny+0.5; ...
          0.5    ny+0.5; ...
          0.5    0.5];

xborder = tformfwd(T,border);
xmin = floor(min(xborder(:,1)));
xmax = ceil(max(xborder(:,1)));
ymin = floor(min(xborder(:,2)));
ymax = ceil(max(xborder(:,2)));

%timg = imtransform(img,T,'bicubic','Fill', 0, ...
%                   'XData',[xmin xmax], ...
%                   'YData',[ymin ymax]);

timg = imtransform(img,T,'bicubic','Fill', 0);