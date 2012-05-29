function A = hg_est_A_from_3p(u)
m = size(u,2);
M = [zeros(3,m) bsxfun(@times,u(6,:),u(1:3,:)) bsxfun(@times,u(5,:),u(1:3,:)); ...
     bsxfun(@times,u(3,:),u(4:6,:)) zeros(3,m) bsxfun(@times,u(2,:),u(4:6,:))]';

if m > 3
    S = diag(1./max(abs(M)));
    invS = diag(1./diag(S));
end

[~,~,V] = svd(M*S);
a = invS*V(:,end);
yA = [reshape(a(1:6),3,2)';[0 0 a(7,end)]];