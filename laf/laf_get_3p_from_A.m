function v = laf_get_3p_from_A(A)
u = laf_renormI(v);

n = size(u,2);
A = squeeze(reshape([u(7:9,:)-u(4:6,:); ...
                    u(1:3,:)-u(4:6,:); ...
                    u(4:6,:)], ...
                    3,3,[]));

u = reshape(A,9,[]);
v = u([4:6 7:9 1:3],:)'
v([1:3 7:9],:) = v([1:3 7:9],:)+v([4:6 4:6],:);