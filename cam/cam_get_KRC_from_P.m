function [K R C] = Q2KRC(Q)
M = Q(1:3,1:3);

m3 = norm(M(3,:),2);
m3_sq = m3^2;

k23 = dot(M(2,:),M(3,:))/m3_sq;
k13 = dot(M(1,:),M(3,:))/m3_sq;
k22 = sqrt(dot(M(2,:),M(2,:))/m3_sq-k23^2);
k12 = dot(M(1,:),M(2,:))/m3_sq/k22-k13*k23/k22;
k11 = sqrt(dot(M(1,:),M(1,:))/m3_sq-k12^2-k13^2);

K = [k11 k12 k13; ...
      0  k22 k23; ...
      0   0   1];
R = inv(K)*sign(det(M))/m3*M;
C = -inv(M)*Q(:,4);