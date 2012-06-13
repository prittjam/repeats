function [x2,y2] = draw2d_wireframe_dist(ax1,u,edges,xform)
un = renormI(u);
axes(ax1);

t = [0:0.1:1]';

vx = reshape(un(1,edges),2,[]);
vy = reshape(un(2,edges),2,[]);

draw2d_lines_xform(vx,vy,xform);

x2 = reshape(x,t,[]);
y2 = reshape(y,t,[]);