%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function u = cam_perspective_project(x)
u = bsxfun(@rdivide,x(1:2,:),x(3,:));