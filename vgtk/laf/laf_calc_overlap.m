%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function ov = laf_calc_overlap(u,v)
m = size(u,2);
if m == 1
    Au = {laf_3p_to_A(u)};
    Av = {laf_3p_to_A(v)};
else
    Au = laf_3p_to_A(u);
    Av = laf_3p_to_A(v);
end    
ov = zeros(1,m);

for k = 1:m
    Tu = Au{k}(1:2,3);
    Tv = Av{k}(1:2,3);
    au = Au{k}(1:2,1:2);
    av = Av{k}(1:2,1:2);
    invav = inv(av);
    ov(k) = 0.25*norm(inv(av)*au-eye(2),'fro')^2+norm(inv(av)*(Tu-Tv),2)^2;
end