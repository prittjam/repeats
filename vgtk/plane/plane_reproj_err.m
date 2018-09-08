%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function err = plane_reproj_err(u,n)
if (size(u,1) == 3)
    u = [u;ones(1,size(u,2))];
end
err = sum(bsxfun(@times,u,n));