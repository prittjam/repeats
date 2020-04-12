%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%

function M = params_to_mtx(a)
n = size(a,2);
if size(a,1) < 4
    a(4,:) = ones(1,n);
end

R = repmat(eye(3,3),1,1,n);
R(1,1,:) = a(4,:);

c = cos(a(1,:));
s = sin(a(1,:));
z = zeros(1,n);
M = reshape([c;s;z;-s;c;z;a(2,:);a(3,:); ...
             ones(1,n)],3,3,n);
M = multiprod(M,R);