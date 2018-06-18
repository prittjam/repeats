function ell = ell_from_laf(u)
n = size(u,2);
C1 = zeros(3,3,n);

invA = laf_to_invA(u);

C0 = eye(3,3);
C0(3,3) = -1;

ell = zeros(6,n);

for i = 1:n
    C1 = invA{i}'*C0*invA{i};
    ell(:,i) = C1(find(triu(ones(3))));
end