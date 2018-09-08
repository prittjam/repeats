%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function s = pt_is_ideal(u,tol)

if nargin < 2
    tol = eps;
end

un = bsxfun(@times,sign(u(3,:)),renorm(u));
s = abs(acos(un(3,:))) > pi/2-tol;