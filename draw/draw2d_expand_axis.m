%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function draw2d_expand_axis(ax1,u);
axes(ax1);
v = renormI(u);
pd = min([max(v(1,:))-min(v(1,:)) max(v(2,:))-min(v(2,:))])*0.05;
vv = [axis' [v(1,:);v(1,:);v(2,:);v(2,:)]];
zz = axis;
axis([min([zz(1) min(vv(1,:))-pd]) ...
      max([zz(2) max(vv(2,:))+pd]) ...
      min([zz(3) min(vv(3,:))-pd]) ...
      max([zz(4) max(vv(4,:))+pd])]);
axis equal;