function [] = line_draw(h,l)
N = size(l,2);

cdata = get(h,'CData');
dx = size(cdata,2);
dy = size(cdata,1);

set(h,'XData',[0 dx-1]);
set(h,'YData',[0 dy-1]);

axes(get(h,'Parent'));
axis ij;
top = repmat([0 1 0.5]',1,N);
bottom = repmat([0 1 0.5-dy]',1,N);

left = repmat([1 0 0.5]',1,N);
right = repmat([1 0 0.5-dx]',1,N);

pts = [line_intersect(l,top);...
       line_intersect(l,bottom);...
       line_intersect(l,left);...
       line_intersect(l,right)];

ia = [repmat((pts(1,:) > -0.5) & (pts(1,:) < dx+0.5),2,1);...
      repmat((pts(3,:) > -0.5) & (pts(3,:) < dx+0.5),2,1);...
      repmat((pts(6,:) > -0.5) & (pts(6,:) < dy+0.5),2,1);...
      repmat((pts(8,:) > -0.5) & (pts(8,:) < dy+0.5),2,1)];

pts2 = reshape(pts(ia(:)),2,[]);

hold on;
lh = line(reshape(pts2(1,:),2,[]), ...
          reshape(pts2(2,:),2,[]));
hold off;

set(lh, ...
    'Color', [204/255 85/255 0], ...
    'LineWidth', 1.25);