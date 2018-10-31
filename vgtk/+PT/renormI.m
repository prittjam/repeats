%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function y = renormI(x)
m = size(x,1);
x = reshape(x,3,[]);
y = reshape(x./x(end,:),m,[]);