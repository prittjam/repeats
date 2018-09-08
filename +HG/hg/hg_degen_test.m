%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function is_degen = hg_degen_test(C, u, inlying_set, t)
H = hg_2e(C);
dx_v = hg_sampson_err(H, u(:,inlying_set));
dx = [reshape(dx_v(1:end/2,:), 2, []) ...
      reshape(dx_v(1:end/2,:), 2, [])];
dx = sqrt(sum(dx,1).^2);
h_inlying_set = dx > 3*t;
pct = sum(h_inlying_set)/sum(inlying_set);
is_degen = false;
if pct > .3
    is_degen = true;
end
