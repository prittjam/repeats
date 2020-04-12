function x = diag_unnormalize(x, cc, k)
    display('RP2.diag_normalize is deprecated. Use RP2.normalize.');
    if nargin < 3
        k = 1;
    end
    sc = sqrt(sum((2*cc).^2)) / 2 / k;
    A = [sc   0    0; ...
        0     sc   0; ...
        0     0    1];
    m = size(x, 1);
    x = reshape(A * reshape(x, 3, []), m, []);
end