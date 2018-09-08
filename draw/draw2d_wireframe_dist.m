%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [xd,yd] = draw2d_wireframe_dist(ax1,u,edges,xform)
t = [0:0.1:1]';
k = numel(t);

vx = reshape(u(1,edges),2,[]);
vy = reshape(u(2,edges),2,[]);

wx = bsxfun(@plus,vx(1,:),bsxfun(@times,t,vx(2,:)-vx(1,:)));
wy = bsxfun(@plus,vy(1,:),bsxfun(@times,t,vy(2,:)-vy(1,:)));

v = tformfwd(xform, [wx(:) wy(:) ones(numel(wx),1)]);

x = reshape(ud(:,1),k,[]);
y = reshape(ud(:,2),k,[]);

axes(ax1);
hold on;
plot(x,y,'k');
hold off;