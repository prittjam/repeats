function [timg,T,rb] = rectify_and_scale(img,H,T0)
Tp = projective2d(H');
x = [0.5 size(img,2)+0.5];
y = [0.5 size(img,1)+0.5];
[tx,ty] = Tp.outputLimits(x,y);

s = sqrt((x(2)-x(1))*(y(2)-y(1))/(tx(2)-tx(1))/(ty(2)-ty(1)));
S = [s 0 0;
     0 s 0;
     0 0 1];

Tp = projective2d((S*H)');

if nargin == 3
    T = maketform('composite',Tp,T0);
else
    T = Tp;
end

ra = imref2d(size(img));
[timg,rb] = imwarp(img,ra,T, ...
                   'bicubic','Fill', ...
                   [255;255;255]);



