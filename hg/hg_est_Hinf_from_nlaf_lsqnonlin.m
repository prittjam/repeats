function [H,v,t,q,resnorm,err] = hg_est_Hinf_from_nlaf_lsqnonlin(u,vis,H0,q0,cc)
u_laf = laf_renormI(blkdiag(H0,H0,H0)*u);

[A,w0] = hg_est_nA_from_ninstances(u_laf,vis);

v0 = blkdiag(A{1},A{1},A{1})*w0;

t0 = zeros(2,numel(A));
invA1 = inv(A{1});
for i = 2:numel(A)
    B = A{i}*invA1;
    t0(:,i) = B(1:2,3);
end

x0 = [zeros(3,1); ...
      zeros(size(v0,2)*6,1); ...
      zeros(numel(t0)-2,1)];
invH0 = inv(H0);
options = optimset('Display','iter');
[x,resnorm,err] = lsqnonlin(@errfun,x0, ...
                            [],[],options, ...
                            u,invH0,v0,t0,q0,cc, ...
                            vis);
[invH,v,t,q] = unwrap(x,invH0,v0,t0,q0);
H = inv(invH);

function err = errfun(x0,u,invH0,v0,t0,q0,cc,vis)
n = size(v0,2);

[invH,v,t,q] = unwrap(x0,invH0,v0,t0,q0);

[ii,jj] = find(vis);
idx = nonzeros(vis);

v2 = renormI(reshape(blkdiag(invH,invH,invH)*(v(:,jj)+t([1:3 1:3 ...
                    1:3],ii)),3,[]));
v3 = cam_dist_div(v2,cc,q);
dz = v3-reshape(u(:,idx),3,[]); 

err = dz(:);

function [invH,v,t,q] = unwrap(x,invH0,v0,t0,q0)
numv = size(v0,2)*6;
numt = numel(t0);
num_dt = numt-2;

dl = x(1:3);
dv = x(4:4+numv-1);
dt = x(4+numv:4+numv+num_dt-1);
dq = x(end);

dH = zeros(3,3);
dH(3,:) = dl;
invH = invH0+dH;

v = v0+reshape([reshape(dv,2,numv/2); ...
                zeros(1,numv/2)],9,[]);
t = [t0+[ [0 0]' reshape(dt,2,num_dt/2) ]; ...
     zeros(1,numt/2)];
q = q0+dq;