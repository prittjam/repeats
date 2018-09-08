%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = util_make_euclidean(u)
v = renormI(u);
v = v(1:end-1,:);