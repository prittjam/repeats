function [Fa] = faff_two_cameras(P1,P2)
    [K, R, C]  = factor_camera_matrix(P1);
    e2 = P2*C;
    e2 = e2/norm(e2);
    Fa = skew(e2)*P2*pinv(P1);
