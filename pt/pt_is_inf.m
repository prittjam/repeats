%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function s = pt_is_inf(u,tol)

if nargin < 2
    tol = pi/180/2;
end

d = 1./sqrt(sum(u.^2));
un = bsxfun(@times,u,d);
s = abs(acos(un(3,:))) < pi/2-tol;