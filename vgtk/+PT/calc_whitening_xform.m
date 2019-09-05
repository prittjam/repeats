function A = calc_whitening_xform(x,k)
if nargin < 2
    k = 3;
end

m = size(x,1);
x = PT.renormI(reshape(x,3,[]));

t = mean(x(1:2,:),2);
C = cov((x(1:2,:)-t)');
W = chol(inv(C))
A = [W -W*t; ...
     0 0 1];