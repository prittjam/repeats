function hd1 = draw2d_rectify_img(ax1,img,H,T1)
nx = size(img,2);
ny = size(img,1);
border = [0.5    0.5; ...
          nx+0.5 0.5; ...
          nx+0.5 ny+0.5; ...
          0.5    ny+0.5; ...
          0.5    0.5];

if nargin < 4
    T = maketform('projective',H');
else
    T = maketform('composite',T1,T2);
end

xborder = tformfwd(T,border);
xmin = floor(min(xborder(:,1)));
xmax = ceil(max(xborder(:,1)));
ymin = floor(min(xborder(:,2)));
ymax = ceil(max(xborder(:,2)));

timg = imtransform(img,T,'bicubic','Fill', 0, ...
                   'XData',[xmin xmax], ...
                   'YData',[ymin ymax]);
axes(ax1);
hd1 = imshow(timg);