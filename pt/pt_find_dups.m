%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [ind,ind2] = pt_find_dups(u,tsq)
if nargin < 2
    tsq = eps;
end

m = size(u,2);
d2 = pdist(u');

[ii,jj] = find(tril(ones(m,m),-1));
ind = ii(find(d2<tsq));
ind2 = unique(jj(find(d2<tsq)));
