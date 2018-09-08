%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function u = laf_A_to_3p(A0)
if iscell(A0)
    A = reshape(cell2mat(A0'),3,3,[]);
else
    A = A0;
end

v = reshape(A,9,[]);
n = size(v,2);
u = zeros(9,n);
u(4:6,:) = v(7:9,:);
u(1:3,:) = v(4:6,:)+u(4:6,:);
u(7:9,:) = v(1:3,:)+u(4:6,:);