function [R t] = eg_get_Rt_from_E(u,E)
N = size(u,2);

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

M = 5;

s = randsample([1:N],min([M N]));
%y2 = repmat(u(4,s),3,1);
%
for i = 1:4
    X = pt_triu_1p2(u,P1,PP(:,:,i));
     
%    R = PP(1:3,1:3,i);
%    t = PP(:,end,i);
%    r1 = repmat(R(1,1:3)',1,M);
%    r3 = repmat(R(3,1:3)',1,M);
%    x3 = repmat(t'*(r1-y2.*r3)./sum(u(1:3,s).*(r1-y2.*r3)),2,1);
%
%    X = [x3.*u(1:2,s); ...
%         x3(1,:); ...
%         ones(1,M)];
    x = PP(:,:,i)*X;
    if (median(X(3,:)) > 0) & (median(x(3,:)) > 0)
        P2 = PP(:,:,i);
        break;
    end
end

R = P2(1:3,1:3);
t = P2(:,end);