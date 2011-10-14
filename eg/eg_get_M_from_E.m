function M = eg_get_M_from_E(u,E)
n = size(u,2);

[U S V] = svd(E);

W = [0 -1  0; ...
     1  0  0; ...
     0  0  1];

PP = zeros(3,4,4);

PP(:,:,1) = [U*W*V' U(:,3)];
PP(:,:,2) = [PP(1:3,1:3,1) -PP(:,4,1)];
PP(:,:,3) = [U*W'*V' U(:,3)];
PP(:,:,4) = [PP(1:3,1:3,3) -PP(:,4,3)];

P1 = [eye(3,3) zeros(3,1)];

m = 5;

s = randsample([1:n],min([m n]));
%y2 = repmat(u(4,s),3,1);
%
for i = 1:4
    X = pt_triu_1p2(u(:,s),P1,PP(:,:,i));
     
%    R = PP(1:3,1:3,i);
%    t = PP(:,end,i);
%    r1 = repmat(R(1,1:3)',1,m);
%    r3 = repmat(R(3,1:3)',1,m);
%    x3 = repmat(t'*(r1-y2.*r3)./sum(u(1:3,s).*(r1-y2.*r3)),2,1);
%
%    X = [x3.*u(1:2,s); ...
%         x3(1,:); ...
%         ones(1,m)];
    x = PP(:,:,i)*X;
    if (median(X(3,:)) > 0) & (median(x(3,:)) > 0)
        M = PP(:,:,i);
    end
end