%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = laf_tforminv(T,u)
v = ones(size(u));
u1 = reshape(u,3,[]);
v0 = reshape(tforminv(T,u1(1:2,:)')',6,[]);
v([1 2 4 5 7 8],:) = v0;