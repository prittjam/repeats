function [] = line_draw(h,l)
N = size(l,2);

[img,ax,fig] = get_drawing_handles(h);

axes(ax);
v = axis;

cdata = get(img,'CData');

dx = size(cdata,2);
dy = size(cdata,1);

set(img,'XData',[0 dx-1]);
set(img,'YData',[0 dy-1]);

x1 = v(1); x2 = v(2); y1 = v(3); y2 = v(4);

top = repmat([0 1 -y1]',1,N);
bottom = repmat([0 1 -y2]',1,N);

left = repmat([1 0 -x1]',1,N);
right = repmat([1 0 -x2]',1,N);

pts = [line_intersect(l,top);...
       line_intersect(l,bottom);...
       line_intersect(l,left);...
       line_intersect(l,right)];

ia = [repmat((pts(1,:) > x1) & (pts(1,:) < x2),2,1);...
      repmat((pts(3,:) > x1) & (pts(3,:) < x2),2,1);...
      repmat((pts(6,:) > y1) & (pts(6,:) < y2),2,1);...
      repmat((pts(8,:) > y1) & (pts(8,:) < y2),2,1)];

pts2 = reshape(pts(ia(:)),2,[]);

hold on;
lh = line(reshape(pts2(1,:),2,[]), ...
          reshape(pts2(2,:),2,[]));
hold off;
axis ij;

set(lh, ...
    'Color', [204/255 85/255 0], ...
    'LineWidth', 1.25);