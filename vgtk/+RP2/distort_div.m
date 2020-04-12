function xd = distort_div(x, q, varargin)
    m = size(x, 1);
    xd = reshape(CAM.distort_div(reshape(x, 3, []), q, varargin), m, []);
end