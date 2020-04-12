%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = translate(u,du)
v = u;
v(1:2,:) = u(1:2,:)+du(1:2,:);
