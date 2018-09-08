%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function A = laf_3p_to_A(v)
u = laf_renormI(v);

A = squeeze(reshape([u(7:9,:)-u(4:6,:); ...
                    u(1:3,:)-u(4:6,:); ...
                    u(4:6,:)], ...
                    3,3,[]));

if ndims(A) > 2
    A = squeeze(mat2cell(A,3,3,ones(1,size(A,3))));
end