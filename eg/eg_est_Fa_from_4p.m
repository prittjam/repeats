%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [Fa] = eg_est_Fa_from_4p(u)
    x1 = [u(1:3,:)];
    x2 = [u(4:6,:)];

    T1 = pt_make_hartley_xform(x1);
    T2 = pt_make_hartley_xform(x2);

    T1 = eye(3,3);
    T2 = eye(3,3);

    x1p=(T1*x1)';
    x2p=(T2*x2)';
    X = [x2p(:,1:2) x1p(:,1:2)];

    c = mean(X);
    dX = X-repmat(c,size(X,1),1);
    [U S V] = svd(dX);
    Fa(1:2,3) = V(1:2,4);
    Fa(3,1:2) = V(3:4,4);
    Fa(3,3) = -dot(V(:,4),c);
    Fa = {T2'*Fa*T1};

%    Fa = [];
%
%    x2 = u(4:6,s);
%    x1 = u(1:3,s);
%
%    A = [x2(1:2,:)' x1(1:2,:)' ones(size(x2,2),1)];
%    f = null(A);
%
%    if ~isempty(f)
%        Fa = zeros(3,3);
%        Fa(1:2,3) = f(1:2);
%        Fa(3,1:2) = f(3:4);
%        Fa(3,3) = f(5);
%    end
%
%    Fa = {Fa};