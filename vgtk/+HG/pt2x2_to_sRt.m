function H = pt2x2_to_sRt(u)
A = eye(3,3);
%
%[u,A] = do_hartley(u);
%
n = size(u,2);
v0 = PT.renormI(u(1:3,:))';
v1 = PT.renormI(u(4:6,:))';

z = zeros(n,1);
o = ones(n,1);

M = [v0(:,1) -v0(:,2) o z; ...
     v0(:,2)  v0(:,1) z o];  
b = [v1(:,1);v1(:,2)];

x = pinv(M)*b;

H = [x(1) -x(2) x(3); ...
     x(2)  x(1) x(4); ...
     0       0     1];

H = H*A;

function [v,A] = do_hartley(u)
v = reshape(u,3,[]);
v = PT.renormI(v);

tx = mean(v(1,:));
ty = mean(v(2,:));
v(1,:) = v(1,:) - tx;
v(2,:) = v(2,:) - ty;
dsc = max(max(abs(v(1:2,:)),[],2));
v(1:2,:) = v(1:2,:)/dsc;

v = reshape(v,6,[]);

A = eye(3);
A([1,2],3) = -[tx ty] / dsc;
A(1,1) = 1 / dsc;
A(2,2) = 1 / dsc;
