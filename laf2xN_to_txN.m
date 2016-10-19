function t = laf2xN_to_txN(u)
M = size(u,2);

u_ii = u(1:9,:);
mu_ii = (u_ii(1:2,:)+u_ii(4:5,:)+u_ii(7:8,:))/3;

u_jj = u(10:18,:);
mu_jj = (u_jj(1:2,:)+u_jj(4:5,:)+u_jj(7:8,:))/3;

t = mu_jj-[c.*mu_ii(1,:)-s.*mu_ii(2,:); ...
           s.*mu_ii(1,:)+c.*mu_ii(2,:)];