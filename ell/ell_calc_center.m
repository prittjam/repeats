function m = ell_calc_center(C)
c = -[C(end,1:end-1)]';
m = [C(1:end-1,1:end-1)\c;1];