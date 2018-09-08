%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function S = hg_est_S_from_1laf(u,s)
if nargin < 2
    s = true(1,size(u,2));
end
u = u(:,s);
S = hg_est_S_from_2p([reshape(u(1:9,:),3,[]); ...
                    reshape(u(10:18,:),3,[])]);