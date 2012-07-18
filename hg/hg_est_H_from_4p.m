function H = u2H(u,u0)
if size(u,1) == 2
    u = [u;ones(1,size(u,2))];
    u0 = [u0;ones(1,size(u0,2))];
end

m = size(u,2);
z = zeros(m,3);
M = [u' z  bsxfun(@times,-u0(1,:),u)'; ...
     z  u' bsxfun(@times,-u0(2,:),u)'];  
[U S V] = svd(M);
H = reshape(V(:,end),3,3)';