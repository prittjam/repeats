function A = make_diag_normalization(cc)
    sc = sqrt(sum((2*cc).^2)) / 2;
    A = make_A(cc, sc);
end

function A = make_A(cc, sc)
    A = [1/sc   0  -cc(1)/sc; ...
         0   1/sc  -cc(2)/sc; ...
         0     0       1];
end