function dx = eg_sampson_err(u,s,sample,F,cfg)
l = blkdiag(F,F')*u(:,s);
e = dot(u(1:3,s),l(4:6,s));
Jt = l([1 2 4 5],:);
invJJt = 1./dot(Jt,Jt);
e2 = e.*invJJt;
dx = bsxfun(@times,-Jt,e2);