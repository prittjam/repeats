function [] = draw2d_estimated_line_segment(ax1,u,l)
u = renormI(u);
d = sqdist(u);
[max_d,idx] = max(d(:));
[i,j] = ind2sub(size(d),idx);
u1 = u(:,i);
u2 = u(:,j);

ln = l/norm(l);
v = [ u1+ln*dot(u1,ln) u2+ln*dot(u2,ln) ];

hold on;
plot(v(1,:)',v(2,:)');
hold off;

