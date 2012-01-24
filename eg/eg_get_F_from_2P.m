function F = eg_get_F_from_2P(P1,P2)
[K R C] = cam_factor_P(P1);
e2 = P2*C;
F = mtx_make_skew_3x3(e2)*P2*pinv(P1);