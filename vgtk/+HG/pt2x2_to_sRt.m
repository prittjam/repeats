%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function H = pt2x2_to_sRt(u)
n = size(u,2);
v0 = PT.renormI(u(1:3,:))';
v1 = PT.renormI(u(4:6,:))';

z = zeros(n,1);
o = ones(n,1);

M = [v0(:,1) -v0(:,2) o z; ...
     v0(:,2)  v0(:,1) z o];  
b = [v1(:,1);v1(:,2)];

x = pinv(M)*b;

H = [x(1) -x(2) x(3); ...
     x(2)  x(1) x(4); ...
     0       0     1];
