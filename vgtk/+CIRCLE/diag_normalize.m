function circ = diag_normalize(circ, cc, k)
    % circ -- [x; p; n] == [xc; yc; R; px; py; nx; ny]
    % or
    % circ -- [x]

    display('CIRCLE.diag_normalize is deprecated. Use CIRCLE.normalize.');
    if nargin < 3
        k = 1;
    end
    sc = sqrt(sum((2*cc).^2)) / 2 / k;
    A = [1/sc   0      0; ...
        0       1/sc   0; ...
        0       0      1];
    c = A * PT.homogenize(circ(1:2,:));
    p = A * PT.homogenize(circ(4:5,:));
    circ(1:2,:) = c(1:2,:);
    circ(3,:) = circ(3,:) / sc;
    circ(4:5,:) = p(1:2,:);
end