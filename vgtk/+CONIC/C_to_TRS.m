%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function A = get_TRS_from_C(C)
m = ELL.get_center(C);
T = MTX.make_T(m(1:2));
U = [chol(C(1:2,1:2))   zeros(2,1); ...
     zeros(1,2)        1];
A = T*inv(U);
s33 = A'*C*A;
A = A*[1 0 0; 0 1 0;0 0 1/sqrt(-s33(3,3))];