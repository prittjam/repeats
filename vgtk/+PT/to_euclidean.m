%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function x2 = to_euclidean(x)
x1 = PT.renormI(x);
x2 = x1(1:end-1,:);
