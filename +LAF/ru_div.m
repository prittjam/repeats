%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = ru_div(u,cc,k)
v = reshape(CAM.ru_div(reshape(u,3,[]),cc,k),9,[]);
