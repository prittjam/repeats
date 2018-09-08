%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function dx = ao_reproj_err(u,M)
Xw = u(4:7,:);

Xc1 = M*Xw;
u1 = Xc1([1 2],:)./Xc1([3 3],:);

% reprojection err in image (in pixels)
dx = u1-u(1:2,:);