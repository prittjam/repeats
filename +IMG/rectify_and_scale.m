function [timg,T2,rb] = rectify_and_scale(img,H,T1)
if nargin < 3
    T1 = [];
end

T = projective2d(H');
x = [0.5 size(img,2)+0.5];
y = [0.5 size(img,1)+0.5];
[tx,ty] = T.outputLimits(x,y);

s = sqrt((x(2)-x(1))*(y(2)-y(1))/(tx(2)-tx(1))/(ty(2)-ty(1)));
S = [s 0 0;
     0 s 0;
     0 0 1];

ra = imref2d(size(img));
T2 = projective2d((S*H)');

[timg,rb] = imwarp(img,ra,T2, ...
                   'bicubic','Fill', ...
                   [255;255;255]);