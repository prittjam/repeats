function A = laf_get_A_from_3p(v)
u = laf_renormI(v);

n = size(u,2);
A = squeeze(reshape([u(7:9,:)-u(4:6,:); ...
                    u(1:3,:)-u(4:6,:); ...
                    u(4:6,:)], ...
                    3,3,[]));

if ndims(A) > 2
    A = squeeze(mat2cell(A,3,3,ones(1,size(A,3))));
end