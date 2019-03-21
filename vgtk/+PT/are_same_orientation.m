%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [flag,side] = are_same_orientation(x,l)
m = size(x,1)/3;
x = reshape(x,3,[]);
z = l'*x;
side = z/z(1) > 0;
flag = all(side);
if m > 1
    side = reshape(side,m,[]);
    ismixed = any(side ~= side(1,:));
    side = prod(side);
    side(ismixed) = nan;
end
side = findgroups(side);