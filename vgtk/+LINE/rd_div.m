%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function c = rd_div(q,cc,l)
assert(q ~= 0, 'The division model parameter must be non-zero');

l = PT.renormI(l);
c = zeros(size(l));
cc = reshape(cc,2,[]);

l = inv([1 0 -cc(1); 0 1 -cc(2); 0 0 1])'*l;
l = bsxfun(@rdivide,l,l(3,:));
c(1:2,:) = -l(1:2,:)/2/q;
c(3,:) = sqrt(sum(c(1:2,:).^2)-1/q);
c(1:2,:) = c(1:2,:)+cc;