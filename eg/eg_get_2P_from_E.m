function [P1 P2] = eg_get_2P_from_E(u,E,K)
P1 = K*[eye(3,3) zeros(3,1)];
M = eg_get_M_from_E(u,E,K);
P2 = K*M;