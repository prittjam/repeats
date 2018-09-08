%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = laf_renormI(u)
v = [bsxfun(@rdivide,u(1:3,:),u(3,:)); ...
     bsxfun(@rdivide,u(4:6,:),u(6,:)); ...
     bsxfun(@rdivide,u(7:9,:),u(9,:))];