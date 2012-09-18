function [X,s1,s2] = cam_triangulate_2p2(u,P1,P2)
n = size(u,2);
X = zeros(4,n);
s1 = zeros(1,n);
s2 = zeros(1,n);
b = [P1(:,4); P2(:,4)];
for j = 1:n
    M = [u(1:3,j)    zeros(3,1) -P1(:,1:3); ...
         zeros(3,1)  u(4:6,j)   -P2(1:3,1:3)];
    x = M\b;
    X(:,j) = [x(3:end);1];
    s1(j) = x(1);
    s2(j) = x(2);
end