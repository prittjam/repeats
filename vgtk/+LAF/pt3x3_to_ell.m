function [ell,CC] = to_ell(u)
n = size(u,2);
C1 = zeros(3,3,n);

invA = LAF.p3x3_to_invA(u);

C0 = eye(3,3);
C0(3,3) = -1;

ell = zeros(6,n);
C1 = cell(1,n);

for i = 1:n
    CC{i} = invA{i}'*C0*invA{i};
    C1 = CC{i};
    ell(:,i) = C1(find(triu(ones(3))));
end