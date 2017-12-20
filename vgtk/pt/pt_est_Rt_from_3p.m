function [R,t0] = pt_est_Rt_from_3p(u,v)
c0 = zeros(2,2);

c0(:,1) = mean(u,2);
a = bsxfun(@minus,u,c0(:,1));

c0(:,2) = mean(v,2);
b = bsxfun(@minus,v,c0(:,2));

c = a*b';
mx = max(abs(c));
D = diag(1./c);
[~,~,V] = svd(c*D);
V2 = D*V;

[U,~,V] = svd(a*b');
R = V*U';
theta0 = atan2(R(2,1),R(1,1));
t0 = c0(:,2)-R*c0(:,1);