function [A,v] = hg_est_nA_from_ninstances(u,vis)
m = size(vis,1);
n = 5+2*m;
k = nnz(vis);

M = zeros(6*k,n);

v = rptsim_est_template(u,vis); 
vist = vis';
idx = nonzeros(vist);
v2 = reshape(u(:,idx), ...
             3,[]);
[ii,jj] = find(vist);
jj = repmat(jj',3,1);

u2 = reshape(v(:,ii), ...
             3,[]);

M(1:2:end,[1 2]) = u2(1:2,:)';
M(2:2:end,[2+m+1 2+m+2]) = u2(1:2,:)';

M(1:2:end,end) = -v2(1,:)';
M(2:2:end,end) = -v2(2,:)';

M(sub2ind(size(M),1:2:size(M,1),2+jj(:)')) = 1;
M(sub2ind(size(M),2:2:size(M,1),4+m+jj(:)')) = 1;

mx = max(abs(M));
D = diag(1./mx);
[~,~,V] = svd(M*D);
V2 = D*V;

z = V2(:,end)./V2(end,end);

a11 = z(1);
a12 = z(2);
a21 = z(m+3);
a22 = z(m+4);

AA = repmat([a11 a12 0; a21 a22 0; 0  0 1], ...
            [1 1 m]);
t = permute([z(3:3+m-1)'; ...
             z(5+m:5+2*m-1)'],[1 3 2]);
AA(1:2,3,:) = t;

A = mat2cell(AA,3,3,ones(1,size(AA,3)));