function [l N] = hg_3laf_to_linf(u,rsc)
X = u(1:2,:);

tx = mean(X(1,:));
ty = mean(X(2,:));
X(1,:) = X(1,:) - tx;
X(2,:) = X(2,:) - ty;
dsc = max(abs(X(:)));

X = X / dsc;

A = eye(3);
A([1,2],3) = -[tx ty] / dsc;
A(1,1) = 1 / dsc;
A(2,2) = 1 / dsc;

sc_norm = min(abs(rsc));

Z = [X(1,:); X(2,:); -sc_norm./rsc(:)']';

hs = pinv(Z) * -ones(size(X,2),1);

l = [hs(1) hs(2) 1]';
N = [A(1,1) A(1,3) A(2,3)]';