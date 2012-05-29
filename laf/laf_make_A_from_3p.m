function A = laf_make_A_from_3p(v)
u = laf_renormI(v);

n = size(u,2);
A = squeeze(reshape([u(1:3,:)-u(4:6,:); ...
                    u(7:9,:)-u(4:6,:); ...
                    u(4:6,:)], ...
                    3,3,[]));

if ndims(A) > 2
    A = num2cell(A,[1 2]);
end