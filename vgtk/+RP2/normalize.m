function x = normalize(x, varargin)
    A = CAM.make_norm_xform(varargin{:});
    m = size(x, 1);
    x = reshape(A * reshape(x, 3, []), m, []);
end