function [S,R,c,t] = hg_est_S_from_2p(u)
n = size(u,2);

ua = renormI(u(1:3,:));
ub = renormI(u(4:6,:));

x = ua(1:2,:);
y = ub(1:2,:);

mx = mean(x,2);
my = mean(y,2);

%sx = 1/(n-1)*sum(sum(x.*x))-mx'*mx;
sx = 1/n*sum(sum(bsxfun(@minus,x,mx).^2));

%sxy = x*y'/(n-1)-mx*my';
sxy = cov(x,y);
sxy = 1/n*x*y'-mx*my';

if any(isnan(sxy))
    S = eye(3,3);
    return;
end

[U,D,V] = svd(sxy);

S = eye(2); 

if det(sxy) < 0
    S(end,end) = -1;
end

R = V'*S*U;
%R = U*S*V';
c = 1/sx*trace(D*S);
t = my-c*R*mx;

S = [c*R t; 0 0 1];
