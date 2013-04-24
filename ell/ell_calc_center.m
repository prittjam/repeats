function [x] = ell_calc_center(C)
c = -[C(end,1:end-1)]';
x = C(1:end-1,1:end-1)\c;