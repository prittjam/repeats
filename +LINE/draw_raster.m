function draw_raster(img,x1,y1,x2,y2)
% distances according to both axes
xn = abs(x2-x1);
yn = abs(y2-y1);

% interpolate against axis with greater distance between points;
% this guarantees statement in the under the first point!
if (xn > yn)
    xc = x1 : sign(x2-x1) : x2;
    yc = round( interp1([x1 x2], [y1 y2], xc, 'linear') );
else
    yc = y1 : sign(y2-y1) : y2;
    xc = round( interp1([y1 y2], [x1 x2], yc, 'linear') );
end

% 2-D indexes of line are saved in (xc, yc), and
% 1-D indexes are calculated here:
ind = sub2ind( size(img), yc, xc );

% draw line on the image (change value of '255' to one that you need)
img(ind) = 255;
