function [un,A] = normalize(u,cc)
sc = sum(2*cc);
ncc = -cc/sc;
A = [1/sc 0        ncc(1); ...
     0       1/sc  ncc(2); ...
     0       0      1];
un = A*u;
