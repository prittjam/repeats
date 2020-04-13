function xd = rd_div(x, cc, q)
    m = size(x, 1);
    xd = reshape(CAM.rd_div(reshape(x, 3, []), cc, q), m, []);
end