function [hh,v] = draw2d_est_line_segment(ax1,u,l)
u = renormI(u);

v = line_project_points(ax1,u,l);

hold on;
hh = plot(v(1,:)',v(2,:)','r');
hold off;

draw2d_expand_axis(ax1,v);

function x = line_project_points(ax1,u,l1)
n = size(u,2);
d = sqdist(u);

lt = l1./sqrt(l1(1)^2+l1(2)^2);
c = (lt(1)*u(2,:)-lt(2)*u(1,:));
l2 = [repmat(lt(2),1,n);repmat(-lt(1),1,n);c];

draw2d_lines(ax1,l1);
x = renormI(cross(repmat(l1,1,n),l2,1));