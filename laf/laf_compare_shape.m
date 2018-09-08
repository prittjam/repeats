%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function d = laf_compare_shape(u,v)
Au = mat2cell(laf_3p_to_A(u));
Av = mat2cell(laf_3p_to_A(v));
invAu = mat2cell(laf_3p_to_invA(u));

d = zeros(1,size(u,2));
I2 = eye(2,2);

T1 = Au(1:2,3,:);
T2 = Av(1:2,3,:);

for k = 1:numel(d)
    d(k) = 1/4*norm(invAu(1:2,1:2,k)*Av(1:2,1:2,k)-I2,'fro')^2+(norm(invAu(1:2,1;2)*(T2-T1)))^2;
end