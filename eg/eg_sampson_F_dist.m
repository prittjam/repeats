%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function dx = eg_F_sampson_dist(u,F)
l = blkdiag(F,F')*u;
e = dot(u(1:3,:),l(4:6,:));
Jt = l([1 2 4 5],:);
e2 = e./dot(Jt,Jt);
dx = bsxfun(@times,-Jt,e2);