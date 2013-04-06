function H = hg_est_H_from_4p(v,s)
u = renormI(v(1:3,s));
u0 = renormI(v(4:6,s));

m = size(u,2);
z = zeros(m,3);
M = [u' z  bsxfun(@times,-u0(1,:),u)'; ...
     z  u' bsxfun(@times,-u0(2,:),u)'];  

S = eye(size(M,2),size(M,2));
if sum(s) > 4
    S = diag(1./max(abs(M)));
end
invS = diag(1./diag(S));

[U S V] = svd(M*S);
H = { reshape(invS*V(:,end),3,3)' };