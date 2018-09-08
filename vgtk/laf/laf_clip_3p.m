%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function s = laf_clip_3p(pts,x)
n = size(pts,2);
x2 = repmat(x(:),1,n);

s1 = pts(1,:) > x2(1,:) & ...
     pts(4,:) > x2(1,:) & ...
     pts(7,:) > x2(1,:);

s2 = pts(1,:) < x2(2,:) & ...
     pts(4,:) < x2(2,:) & ...
     pts(7,:) < x2(2,:);

s3 = pts(2,:) > x2(3,:) & ...
     pts(5,:) > x2(3,:) & ...
     pts(8,:) > x2(3,:);

s4 = pts(2,:) < x2(4,:) & ...
     pts(5,:) < x2(4,:) & ...
     pts(8,:) < x2(4,:);

s = s1 & s2 & s3 & s4;