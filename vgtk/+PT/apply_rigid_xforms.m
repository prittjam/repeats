%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = apply_rigid_xforms(u,theta,t)
c = cos(theta);
s = sin(theta);
v = u;
v(1:2,:) = [ c.*u(1,:)-s.*u(2,:); ...
             s.*u(1,:)+c.*u(2,:)]+t;
