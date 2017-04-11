function [K R c] = P_to_KRc(Q)
alpha = sign(det(Q(1:3,1:3)))/norm(Q(3,1:3));
M = alpha*Q(1:3,1:3);

k23 = dot(M(2,:),M(3,:));
k13 = dot(M(1,:),M(3,:));
k22 = sqrt(dot(M(2,:),M(2,:))-k23^2);
k12 = (dot(M(1,:),M(2,:))-k13*k23)/k22;
k11 = sqrt(dot(M(1,:),M(1,:))-k12^2-k13^2);

K = [k11 k12 k13; ...
      0  k22 k23; ...
      0   0   1];

R = inv(K)*Q(1:3,1:3);
c = M(1:3,1:3)\Q(:,4);
