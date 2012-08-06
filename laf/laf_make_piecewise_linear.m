function [x,y] = draw2d_make_piecewise_linear_lafs(u)
t = [0:0.1:1]';
k = numel(t);

x = [bsxfun(@plus,u(1,:),bsxfun(@times,t,u(4,:)-u(1,:))); ...
     bsxfun(@plus,u(4,:),bsxfun(@times,t,u(7,:)-u(4,:)))];

y = [bsxfun(@plus,u(2,:),bsxfun(@times,t,u(5,:)-u(2,:))); ...
     bsxfun(@plus,u(5,:),bsxfun(@times,t,u(8,:)-u(5,:)))];