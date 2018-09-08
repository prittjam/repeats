%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function is_degen = hg_3laf_to_Hinf_degen(u)
ind = [1 2 3];
du = u(1:2,[1 2 3])-u(1:2,[2 3 1]);
du = bsxfun(@rdivide,du(1:2,:),sqrt(sum(du(1:2,:).^2,1)));
du2 = du(:,[2 3 1]);
angle = acos(dot(du,du2));
ind = angle > pi/2;
angle(ind) = pi-angle(ind);
is_degen = all(angle < 15*pi/180);