%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function x = shrink(x,s)
A = LAF.pt3x3_to_A(x);
for k = 1:numel(A);
    B = A{k};
    [U,S,V] = svd(B(1:2,1:2));
    B(1:2,1:2) = U*(s*S)*V';
    A{k} = B;
end
x = LAF.A_to_pt3x3(A);
