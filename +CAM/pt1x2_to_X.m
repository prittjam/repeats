function [X,s] = pt1x2_to_X(u0,s,P1,P2)
F = eg_make_F_from_2P(P1,P2);
dx = eg_sampson_err(u0(:,s),F);

abc = [1 2 4 5];
u(abc,:) = u0(abc,s)+dx;
n = size(u,2);
X = zeros(4,n);
s1 = zeros(1,n);
s2 = zeros(1,n);

%b = [P1(:,4); P2(:,4)];

for j = 1:n
    M = [ u(1,j)*P1(3,:) - P1(1,:); ...
          u(2,j)*P1(3,:) - P1(2,:); ...
          u(4,j)*P2(3,:) - P2(1,:); ...
          u(5,j)*P2(3,:) - P2(2,:); ...
        ];
    mx = max(abs(M));
    D = diag(1./mx);
    [~,~,V] = svd(M*D);
    V2 = D*V;
    [U,D,V] = svd(M);
    X(:,j) = V(:,end);

%    M = [u(1:3,j)    zeros(3,1) -P1(:,1:3); ...
%         zeros(3,1)  u(4:6,j)   -P2(1:3,1:3)];
%    x = M\b;
%    X(:,j) = [x(3:end);1];
%    s1(j) = x(1);
%    s2(j) = x(2);
end

X = renormI(X);
s1 = P1(3,:)*X;
s2 = P2(3,:)*X;
s3 = (s1 < 0) | (s2 < 0);

inl = find(s);
s(inl(s3)) = false;
X(:,s3) = [];