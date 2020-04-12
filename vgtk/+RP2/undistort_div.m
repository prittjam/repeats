function xu = undistort_div(xd, q, varargin)
    m = size(xd, 1);
    xu = reshape(CAM.undistort_div(reshape(xd, 3, []), q, varargin{:}), m, []);
end