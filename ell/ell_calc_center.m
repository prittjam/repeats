function [x] = ell_calc_center(C)
A = [C(1,1) C(1,2);
     C(2,1) C(2,2)];
c = -[C(3,1) C(3,2)]';
x = A\c;