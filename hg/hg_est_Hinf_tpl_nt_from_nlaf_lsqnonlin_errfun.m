function err = hg_est_Hinf_tpl_nt_from_nlaf_lsqnonlin_errfun(x0,u,invH0,v0,t0,q0,cc,vis)
n = size(v0,2);

[invH,v,t,q] = hg_est_Hinf_tpl_nt_from_nlaf_lsqnonlin_unwrap(x0,invH0,v0,t0,q0);

[ii,jj] = find(vis);
idx = nonzeros(vis);

v2 = renormI(reshape(blkdiag(invH,invH,invH)*(v(:,jj)+t([1:3 1:3 ...
                    1:3],ii)),3,[]));
v3 = cam_dist_div(v2,cc,q);
u2 = reshape(u(:,idx),3,[]);

dz = v3(1:2,:)-u2(1:2,:); 
err = dz(:);