%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function un = renorm(u);
d = 1./sqrt(sum(u.^2));
un = bsxfun(@times,u,d);