function x = diag_normalize(x, cc, k)
    display('RP2.diag_unnormalize is deprecated. Use RP2.unnormalize.');
    if nargin < 3
        k = 1;
    end
    sc = sqrt(sum((2*cc).^2)) / 2 / k;
    A = [1/sc   0      0; ...
        0       1/sc   0; ...
        0       0      1];
    m = size(x, 1);
    x = reshape(A * reshape(x, 3, []), m, []);
end