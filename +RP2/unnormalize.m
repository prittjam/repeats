function x = unnormalize(x, A)
    m = size(x, 1);
    x = reshape(A \ reshape(x, 3, []), m, []);
end