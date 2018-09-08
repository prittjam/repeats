%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function x2 = homogenize(x)
    x2 = [x;ones(1,size(x,2))];
