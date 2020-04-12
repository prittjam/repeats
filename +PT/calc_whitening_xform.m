function A = calc_whitening_xform(x,m)
x = PT.renormI(reshape(x,m,[]));
t = mean(x(1:m-1,:),2);
C = cov((x(1:m-1,:)-t)');
try
     W = chol(inv(C));
catch
     W = eye(2,2);
end
A = [W -W*t; ...
     0 0 1];