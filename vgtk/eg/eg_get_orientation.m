%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function a = eg_get_orientation(u,F)
[U,D,V] = svd(F,0);
e2 = renormI(U(:,3));
a = sign(dot(F*u(1:3,:),cross(repmat(e2,1,size(u,2)),u(4:6,:))));