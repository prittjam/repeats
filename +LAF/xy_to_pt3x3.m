%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function u = xy_to_p3x3(x,y)
u = ones(9,numel(x)/3);
u([1 4 7],:) = reshape(x,3,[]);
u([2 5 8],:) = reshape(y,3,[]);