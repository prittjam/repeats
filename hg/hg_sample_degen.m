%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function is_degen = hg_sample_degen(u,sample,varargin)
t = varargin{ 1 };
N = sum(sample);

ia = VChooseK(1:N,3);
is = find(sample);

v = cross(u(1:3,is(ia(:,1))),u(1:3,is(ia(:,2))));
v = v./repmat(sqrt(sum(v.^2)),3,1);
w = renormI(u(1:3,is(ia(:,3))));
d1 = abs(dot(v,w)) < t;

v = cross(u(4:6,is(ia(:,1))),u(4:6,is(ia(:,2))));
v = v./repmat(sqrt(sum(v.^2)),3,1);
w = renormI(u(4:6,is(ia(:,3))));
d2 = abs(dot(v,w)) < t;

ib = VChooseK(1:N,4);

s = sum(d1(ib),2)+sum(d2(ib),2);

is_degen = sum(s == 0) == 0;