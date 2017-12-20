function Rt = laf2xN_to_txN(u)
u_ii = u(1:9,:);
u_jj = u(10:18,:);
s1 = LAF.is_right_handed(u_ii);
s2 = LAF.is_right_handed(u_jj);
hands_switched = xor(s1,s2);

u_ii(:,hands_switched) = LAF.reflect_yaxis(u_ii(:,hands_switched));

N = size(u,2);
mu_ii = (u_ii(1:2,:)+u_ii(4:5,:)+u_ii(7:8,:))/3;
mu_jj = (u_jj(1:2,:)+u_jj(4:5,:)+u_jj(7:8,:))/3;

t = mu_jj-mu_ii;

a11 = -1*hands_switched;
a11(a11==0) = 1;

Rt = [zeros(1,N);t;a11];
