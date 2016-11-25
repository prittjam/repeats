function H = H_from_4pl(u,l)
u1 = renormI(v(1:3,:))';
u2 = renormI(v(4:6,:))';

l1 = renormI(l(1:3,:))';
l2 = renormI(l(4:6,:))';

m = size(u1,1);
z = zeros(m,3);
zz = zeros(m,1);
o = ones(m,1);

M = ...
    [u1 z  bsxfun(@times,-u2(:,1),u1); ...
     z  u1 bsxfun(@times,-u2(:,2),u1); ...
     -l2(:,1) zz l2(:,1).*l1(:,1) -l2(:,2) z l2(:,2).*l1(:,1) -o z l2(:,1); ...
     zz -l2(:,1) l2(:,1).*l1(:,2) z -l2(:,2) l2(:,2).*l1(:,2)  z -o  l2(:,2)];  

S = eye(size(M,2),size(M,2));
if m > 4
    S = diag(1./max(abs(M)));
end
invS = diag(1./diag(S));

[U S V] = svd(M*S);
H = { reshape(invS*V(:,end),3,3)' };