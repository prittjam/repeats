%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [flag,side] = are_same_orientation(u,l)
m = size(u,1)/3;
u = reshape(u,3,[]);
z = l'*u;
side = z/z(1) > 0;
flag = all(side);
if m > 1
    side = prod(reshape(side,m,[]));
end
side = findgroups(side);