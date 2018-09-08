%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function d2 = laf_maxdist(XI,XJ)
d0 = bsxfun(@minus,XI,XJ).^2;
d2 = max([sqrt([sum(d0(:,1:2),2) sum(d0(:,4:5),2) sum(d0(:,7: ...
                                                 8),2)])],[],2);