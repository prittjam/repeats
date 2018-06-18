function [A,m] = get_A_from_C(C)
m = ELL.get_center(C);
T = MTX.make_T(m(1:2));
U = [chol(C(1:2,1:2))   zeros(2,1); ...
     zeros(1,2)        1];
A = T*inv(U);
s33 = A'*C*A;
A = A*[1 0 0; 0 1 0;0 0 1/sqrt(-s33(3,3))];