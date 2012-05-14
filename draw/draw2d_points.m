function [] = draw2d_points(ax1,u)
u = renormI(u);

axes(ax1);

v = axis;
xmin = min([u(1,:) v(1)]);
xmax = max([u(1,:) v(2)]);
ymin = min([u(2,:) v(3)]);
ymax = max([u(2,:) v(4)]);

axis([xmin-5 xmax+5 ymin-5 ymax+5]);

hold on;
hp = scatter(u(1,:),u(2,:));
hold off;

set(get(hp,'Children'), ... 
    'LineWidth', 1,'Marker', 'o', ...
    'MarkerSize', 7, 'MarkerEdgeColor', [.2 .2 .2], ...
    'MarkerFaceColor' , [.75 .75 1]);