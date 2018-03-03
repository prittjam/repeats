function [hh,v] = draw2d_line_segment(ax1,u,l,varargin)
v = line_project_points(ax1,u,l);
draw2d_expand_axis(ax1,v);

hold on;
hh = plot(v(1,:)',v(2,:)',varargin{:});
hold off;

function v = line_project_points(ax1,u,l1)
n = size(u,2);
u = renormI(u);
l1 = renormI(l1);

ln = l1./sqrt(sum(l1(1:2).^2));
d = sum(bsxfun(@times,ln,u));
v = ones(size(u));
v(1:2,:) = u(1:2,:)-bsxfun(@times,d,ln(1:2,:));