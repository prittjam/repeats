%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function s1 = is_right_handed(u)
u = reshape(u,3,[]);
v = cross(u(:,3:3:end)-u(:,2:3:end), ... 
          u(:,1:3:end)-u(:,2:3:end));
s1 = v(3,:) > 0;
