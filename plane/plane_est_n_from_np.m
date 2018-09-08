%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function n = plane_est_n_from_np(u,threshold,confidence)
k = size(u,2);
um = mean(u,2);
u2 = bsxfun(@minus,u,um);
M = (u2*u2')/k;
[~,~,V] = svd(M);
vn = V(:,3);
n = [vn;-dot(vn,um)];