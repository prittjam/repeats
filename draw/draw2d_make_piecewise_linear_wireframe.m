function [x,y] = draw2d_make_piecewise_linear_wireframe(u,edges)
t = [0:0.1:1]';
k = numel(t);

vx = reshape(u(1,edges),2,[]);
vy = reshape(u(2,edges),2,[]);

x = bsxfun(@plus,vx(1,:),bsxfun(@times,t,vx(2,:)-vx(1,:)));
y = bsxfun(@plus,vy(1,:),bsxfun(@times,t,vy(2,:)-vy(1,:)));