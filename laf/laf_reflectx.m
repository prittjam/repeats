%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function u = laf_reflectx(u);
abc = [1 4 7];
u(abc,:) = bsxfun(@times,[-1 -1 -1]',u(abc,:));