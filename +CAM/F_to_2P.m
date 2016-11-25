function [P1 P2] = F_to_2P(F)
[U,D,V] = svd(F,0);
e2 = renormI(U(:,3));
P1 = [eye(3) zeros(3,1)];
P2 = [mtx_make_skew_3x3(e2)*F e2];