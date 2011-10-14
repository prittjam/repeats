function F = eg_get_F_from_P1P2(P1,P2)
[K R C] = factor_camera_matrix(P1);
e2 = P2*C;
F = mtx_make_skew_3x3(e2)*P2*pinv(P1);