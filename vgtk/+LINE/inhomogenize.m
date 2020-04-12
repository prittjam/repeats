%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function l = inhomogenize(l0)
l = l0./sqrt(sum(l0(1:2,:).^2));
