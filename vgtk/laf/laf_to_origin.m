%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function u = laf_to_origin(u)
abc = [1 2 4 5 7 8];
u(abc,:) = u(abc,:)-repmat(u([4 5],:),3,1);