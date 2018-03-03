function [] = pt_draw_tc(im1,im2,u,span)
if nargin < 4
    span = 1;
end

N = size(u,2);
dx = size(im1,2)+size(im2,2);
dy = size(im1,1);

hn = imdisp({im1, im2});

v = zeros(4,N);

v([1 3],:) = u([1 4],:)/dx;
v(3,:) = v(3,:)+size(im1,2)/dx;
v([2 4],:) = u([2 5],:)/dy;

ah3 = axes('Position',[0.0 0.0 1.0 1.0],'Visible','Off');
axes(ah3);
axis([0.0 1.0 0.0 1.0]);

cols = 1:span:N;

hold(ah3,'on');

sh1 = scatter(ah3,v(1,cols),v(2,cols),'green','filled');
set(sh1, 'SizeData', 15);
sh2 = scatter(ah3,v(3,cols),v(4,cols),'green','filled');
set(sh2, 'SizeData', 15);

line([v(1,cols);v(3,cols)], [v(2,cols);v(4,cols)],'Color','blue');
hold(ah3,'off');
axis ij;