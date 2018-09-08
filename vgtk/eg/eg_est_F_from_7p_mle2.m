%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function F = eg_est_F_from_7p_mle2(u,F0,W)
m = 4*size(u,2);

if nargin < 3
    W = ones(m,1);
end

unwrap = @(x) mtx_make_skew_3x3(x(end-2:end))*reshape(x,3,4)*[eye(3); 0 0 0];
err_fn = @(x,u) ...
         reshape(bsxfun(@times,sqrt(W'),eg_sampson_F_dist(u,unwrap(x))),[],1);
[P1,P2] = cam_get_2P_from_F(F0);

x0 = P2(:);

options = optimset('Display', 'Off', ...
                   'Diagnostics', 'Off');

x = lsqnonlin(err_fn, x0,[],[],options,u);
F = unwrap(x);