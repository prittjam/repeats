function [X,s] = cam_triangulate_2p2(u0,s,P1,P2)
u = u0(:,s);

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

s3 = (s1 < 0) | (s2 < 0);
inl = find(u);
s(inl(s3)) = false;
X(:,s3) = [];