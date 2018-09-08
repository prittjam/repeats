%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [Faa] = faff_n_points(x)
    x1 = [x(1:3,:)];
    x2 = [x(4:6,:)];
    [x1p, T1] = hartley_normalize_points(x1);
    [x2p, T2] = hartley_normalize_points(x2);

    x1p=x1p';
    x2p=x2p';
    X = [x2p(:,1:2) x1p(:,1:2)];

    c = mean(X);
    dX = X-repmat(c,size(X,1),1);
    [U S V] = svd(dX);
    Fa(1:2,3) = V(1:2,4);
    Fa(3,1:2) = V(3:4,4);
    Fa(3,3) = -dot(V(:,4),c);
    Faa = {T2'*Fa*T1};
