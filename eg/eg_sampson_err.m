function dx = eg_sampson_err(u,F)
l = blkdiag(F,F')*u;
e = dot(u(1:3,:),l(4:6,:));
Jt = l([1 2 4 5],:);
invJJt = 1./dot(Jt,Jt);
e2 = e.*invJJt;
dx = bsxfun(@times,-Jt,e2);