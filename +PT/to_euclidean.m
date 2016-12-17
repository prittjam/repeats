function x2 = to_euclidean(x)
x1 = PT.renormI(x);
x2 = x1(1:end-1,:);
