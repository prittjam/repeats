%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
yfunction X = pt_triu_1p2(u,P1,P2)
N = size(u,2);
X = zeros(4,N);

for i = 1:N
    A = [ ...
        u(1,i).*P1(3,:)-P1(1,:); ...
        u(2,i).*P1(3,:)-P1(2,:); ...
        u(4,i).*P2(3,:)-P2(1,:); ...
        u(5,i).*P2(3,:)-P2(2,:); ...
        ];
    [U S V] = svd(A);
    X(:,i) = V(:,end);
end

X = renormI(X);