function [] = draw2d_wireframe_xform(ax1,u,edges,xform)
un = renormI(u);
axes(ax1);

t = 0:0.1:1;

vx = reshape(un(1,edges),2,[]);
vy = reshape(un(2,edges),2,[]);

wx = bsxfun(@plus,vx(1,:),bsxfun(@times,t,vx(2,:)-vx(1,:)));
wy = bsxfun(@plus,by(1,:),bsxfun(@times,t,by(2,:)-by(1,:)));

ud = tformfwd(xform, [wx(:) wy(:)]);

x = reshape(ud(:,1),numel(t),[]);
y = reshape(ud(:,2),numel(t),[]);

hold on;
plot(x,y,'k');
hold off;
