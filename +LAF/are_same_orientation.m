%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [flag,side] = are_same_orientation(u,l)
u = reshape(u,3,[]);
z = dot(l(:,ones(1,size(u,2))),u);
side = z/z(1) > 0;
flag = all(side);
side = prod(reshape(side,3,[]));
