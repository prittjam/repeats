%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function flag = is_Hinf_degen(u,H)
v = renormI(H*u);
flag = any(v(3,:)/v(3,1) <= 0);