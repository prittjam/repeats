function H = hg_est_np_tlsq(ut,s,varargin)
u = ut(:,s)';
zero = zeros(sum(s),3);

A = [   zero    -u(:,1:3)   u(:,[5 5 5]).*u(:,1:3); ...
      u(:,1:3)     zero    -u(:,[4 4 4]).*u(:,1:3) ];
[U S V] = svd(A);

H = { reshape(V(:,end),3,3)' };