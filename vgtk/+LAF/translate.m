%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = translate(u,t)
z = zeros(1,size(t,2));
o = ones(1,size(t,2));
v = LAF.apply_rigid_xforms(u,[z;t;o]);
