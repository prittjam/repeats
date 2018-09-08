%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function Rt = laf1x2_to_Rt(v)
u = reshape(v([1:2 10:11 4:5 13:14 7:8 16:17],:),4,[]);    
Rt = HG.p2_to_Rt(u);
