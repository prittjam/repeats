function M = ell_get_TRS_from_C(C)
m = ell_calc_center(C);
T = mtx_make_T(m(1:2));
U = [chol(C(1:2,1:2))   zeros(2,1); ...
     zeros(1,2)        1];
M = T*inv(U);

%U'*T'*C*T*invU;
%/S0(3,3);
%(sqrt(1./abs(diag(S00))));
%T
%