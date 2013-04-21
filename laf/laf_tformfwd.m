function v = laf_tformfwd(T,u)
v = ones(size(u));
u1 = reshape(u,3,[]);
v0 = reshape(tformfwd(T,u1(1:2,:)')',6,[]);
v([1 2 4 5 7 8],:) = v0;