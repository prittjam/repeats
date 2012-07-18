function [H,v,t,q,resnorm,err,resnorm0,err0] = hg_est_Hinf_tpl_nt_from_nlaf_lsqnonlin(u,vis,H0,q0,cc)
u_laf = laf_renormI(blkdiag(H0,H0,H0)*u);

[A,w0] = hg_est_nA_from_ninstances(u_laf,vis);

v0 = blkdiag(A{1},A{1},A{1})*w0;

t0 = zeros(2,numel(A));
invA1 = inv(A{1});
for i = 2:numel(A)
    B = A{i}*invA1;
    t0(:,i) = B(1:2,3);
end

x0 = [zeros(4,1); ...
      zeros(size(v0,2)*6,1); ...
      zeros(numel(t0)-2,1)];

invH0 = inv(H0);
err0 = hg_est_Hinf_tpl_nt_from_nlaf_lsqnonlin_errfun(x0,u,invH0,v0, ...
                                                  t0,q0,cc,vis);
resnorm0 = sum(err0.^2);

options = optimset('Display','none');
[x,resnorm,err] = ...
    lsqnonlin(@hg_est_Hinf_tpl_nt_from_nlaf_lsqnonlin_errfun, ...
              x0,[],[],options, ...
              u,invH0,v0,t0,q0,cc, ...
              vis);

[invH,v,t,q] = hg_est_Hinf_tpl_nt_from_nlaf_lsqnonlin_unwrap(x,invH0,v0,t0,q0);
H = inv(invH);