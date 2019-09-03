%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function y = renormI(x,k)
if nargin < 2
    k = 3
end
m = size(x,1);
x = reshape(x,k,[]);
y = reshape(x./x(end,:),m,[]);