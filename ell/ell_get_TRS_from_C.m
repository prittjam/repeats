function [T,R,S] = ell_get_tRS_from_C(C)
m = ell_calc_center(C);
[R,D] = eig(C(1:2,1:2));
T = mtx_make_T(m(1:2));
S0 = R'*T'*C*T*R;
S00 = S0/S(3,3);
S = [sqrt(1/abs(diag(S0)))];
