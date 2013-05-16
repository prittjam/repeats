function [Fa] = eg_est_Fa_from_4p(u,s,varargin)
    Fa = [];

    x2 = u(4:6,s);
    x1 = u(1:3,s);

    A = [x2(1:2,:)' x1(1:2,:)' ones(size(x2,2),1)];
    f = null(A);

    if ~isempty(f)
        Fa = zeros(3,3);
        Fa(1:2,3) = f(1:2);
        Fa(3,1:2) = f(3:4);
        Fa(3,3) = f(5);
    end

    Fa = {Fa};