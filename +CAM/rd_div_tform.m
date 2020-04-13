%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = rd_div_tform(u,T)
v = CAM.rd_div(u',T.tdata.cc,T.tdata.q)';
