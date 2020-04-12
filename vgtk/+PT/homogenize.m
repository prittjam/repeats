function x2 = homogenize(x, k)
    % Args:
    %   x -- euclidean point(s) in R^k
    %   k -- dimensionality of the real projective space P^k

    if nargin < 2
        k = 2;
    end
    m = size(x, 1);
    assert(mod(m,k) == 0);
    N = m / k;
    x2 = [reshape(x, k, []); ones(1, N * size(x, 2))];
    x2 = reshape(x2, m + N, []);
end
