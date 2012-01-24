function [res,cfg] = eg_est_E(u,K)

threshold = 3;
confidence = 0.99;

if nargin > 1
    invK = mtx_inv_K(K);
    u2 = blkdiag(invK,invK)*u;
    e_threshold = threshold*invK(1,1);
else
    u2 = u;
end

[res,cfg] = eg_est_E_5p_rnsc(u2,e_threshold,confidence);

