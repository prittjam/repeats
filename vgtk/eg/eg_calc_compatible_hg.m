%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function H = calc_compatible_hg(F)
[e1 e2] =  extract_epipoles(F);
s = skew(e2);
A = blkdiag(s,s,s);
h = pinv(A)*F(:);
H = reshape(h,3,3);
