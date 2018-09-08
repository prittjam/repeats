%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function w = laf_undistort_div(u,q,cc)
v = reshape(u,3,[]);
w = reshape(cam_undistort_div(v,cc,q),9,[]);