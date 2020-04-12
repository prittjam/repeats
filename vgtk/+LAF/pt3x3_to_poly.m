%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = p3x3_to_poly(u)
v = [u([1 2 4 5 7 8],:);u([1 2],:)];