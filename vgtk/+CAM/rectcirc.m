%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [xx,yy] = rectcirc(border,cc,c)
m = nan(1,4);
b = nan(1,4);

m = transpose((border([2:4 1],2)-border(1:4,2))./(border([2:4 1],1)-border(1:4,1)));
b(isinf(m)) = border(isinf(m),1);
b(~isinf(m)) = border(~isinf(m),2);
xx = zeros(1,8); 
yy = zeros(1,8); 
for k = 1:4 
    [xx(2*(k-1)+1:2*k),yy(2*(k-1)+1:2*k)]= ...
        linecirc(m(k),b(k),c(1),c(2),c(3));  
end
d2 = sum(bsxfun(@minus,[xx;yy],cc).^2);
[~,ind] = sort(d2);
xx = xx(ind);
yy = yy(ind);
