function xd = distort_div(x, q)
    m = size(x, 1);
    xd = reshape(CAM.distort_div(reshape(x, 3, []), q), m, []);
end