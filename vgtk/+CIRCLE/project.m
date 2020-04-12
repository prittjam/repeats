function [p, n] = project(c, x)
    % Projects point / N points
    % on the circle / N corresponding circles
    % Args:
    %     c -- [3 x N] -- circles
    %     x -- [2/3 x N] -- points on corresponding circles
    if size(x, 1) == 3
        x = PT.renormI(x);
    end
    dirs = x(1:2,:) - c(1:2,:);
    norms = vecnorm(dirs,2,1);
    n = dirs ./ norms;
    p = c(1:2,:) + n .* c(3,:);
    if size(x, 1) == 3
        p = PT.homogenize(p);
    end
end