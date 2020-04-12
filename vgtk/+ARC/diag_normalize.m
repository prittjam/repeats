function arcs = diag_normalize(arcs, cc, k)
    display('ARC.diag_normalize is deprecated. Use ARC.normalize.');
    if nargin < 3
        k = 1;
    end
    sc = sqrt(sum((2*cc).^2)) / 2 / k;
    A = [1/sc   0      0; ...
        0       1/sc   0; ...
        0       0      1];
    arcs = cellfun(@(x) A * x, arcs, 'UniformOutput', false);
end