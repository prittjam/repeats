function F = eg_make_F_from_P1P2(P1,P2)
e2 = P2*[zeros(3,1);1];
F = mtx_make_skew_3x3(e2)*P2*pinv(P1);