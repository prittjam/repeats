%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function s = line_is_ideal(u,tol)

if nargin < 2
    tol = 1e-5;
end

un = renorm(u);
s = acos(un(3,:)) < tol;