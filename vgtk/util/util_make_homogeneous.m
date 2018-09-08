%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = util_make_homogeneous(u)
v = [u;ones(1,size(u,2))];