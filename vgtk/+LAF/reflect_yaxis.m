%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function u = reflect_yaxis(u)
u([1 4 7],:) = -u([1 4 7],:);
