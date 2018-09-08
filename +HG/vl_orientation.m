%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function z = vl_orientation(u,vl)
HH0 = HG.vl_to_Hinf(vl);
z = vl'*reshape(u,3,[]);