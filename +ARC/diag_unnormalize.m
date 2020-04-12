function arcs = diag_unnormalize(arcs, cc, k)
    display('ARC.diag_unnormalize is deprecated. Use ARC.unnormalize.');
    if nargin < 3
        k = 1;
    end
    sc = sqrt(sum((2*cc).^2)) / 2 / k;
    A = [sc   0    0; ...
        0     sc   0; ...
        0     0    1];
    arcs = cellfun(@(x) A * x, arcs, 'UniformOutput', false);
end