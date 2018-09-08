%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function flag = are_same_orientation(u,l)
z = dot(l(:,ones(1,size(u,2))),u);
flag = all(z/z(1) > 0);
