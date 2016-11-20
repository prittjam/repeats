function [Rt,ii,jj] = calc_pwise_xforms(u,est_xform)
M = size(u,2);
[ii,jj] = find(tril(ones(M,M),-1));
Rt = feval(est_xform,[u(:,ii);u(:,jj)]);