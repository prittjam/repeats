function Rt = laf2xN_to_txN(u)
N = size(u,2);

u_ii = u(1:9,:);
mu_ii = (u_ii(1:2,:)+u_ii(4:5,:)+u_ii(7:8,:))/3;

u_jj = u(10:18,:);
mu_jj = (u_jj(1:2,:)+u_jj(4:5,:)+u_jj(7:8,:))/3;

t = mu_jj-mu_ii;

Rt = struct('theta',mat2cell(zeros(1,N),1,ones(1,N)), ...
            't',mat2cell(t,2,ones(1,N))); 
