%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = rd_div(u,cc,k)
m = size(u,1);
v = reshape(CAM.rd_div(reshape(u,3,[]),cc,k),m,[]);