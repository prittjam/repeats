function [invH,v,t,q] = ...
    hg_est_Hinf_tpl_nt_from_nlaf_lsqnonlin_unwrap(x,invH0,v0,t0,q0)

numv = size(v0,2)*6;
numt = numel(t0);
num_dt = numt-2;

dl = x(1:3);
dq = x(4);
dv = x(5:5+numv-1);
dt = x(5+numv:end);

dH = zeros(3,3);
dH(3,:) = dl;
invH = invH0+dH;

v = v0+reshape([reshape(dv,2,numv/2); ...
                zeros(1,numv/2)],9,[]);
t = [t0+[ [0 0]' reshape(dt,2,num_dt/2) ]; ...
     zeros(1,numt/2)];
q = q0+dq;