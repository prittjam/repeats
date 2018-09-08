%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function l = make_orthogonal(lp,x)
    l = LINE.inhomogenize(lp);
    tmp = l(1,:);
    l(1,:) = -l(2,:);
    l(2,:) = tmp;
    l(3,:) = -dot(l(1:2,:),x(1:2,:)); 
