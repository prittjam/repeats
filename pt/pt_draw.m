function [] = pt_draw(h,u)
[img,ax,fig] = get_drawing_handles(h);

axes(ax);
axis image;

cdata = get(img,'CData');

dx = size(cdata,2);
dy = size(cdata,1);

set(img,'XData',[0 dx-1]);
set(img,'YData',[0 dy-1]);

min_x = min([u(1,:) 0]);
max_x = max([u(1,:) dx-1]);

min_y = min([u(2,:) 0]);
max_y = max([u(2,:) dy-1]);

axis([min_x max_x min_y max_y]);

hold on;
hp = scatter(u(1,:),u(2,:));
hold off;

set(get(hp,'Children'), ... 
    'LineWidth', 1,'Marker', 'o', ...
    'MarkerSize', 7, 'MarkerEdgeColor', [.2 .2 .2], ...
    'MarkerFaceColor' , [.75 .75 1]);

