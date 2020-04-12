function f_px = f_mm_to_px(f_mm, nx, ccd_mm)
    if nargin < 3
        ccd_mm = 36; % 36 mm equivalent
    end
    f_px = nx * f_mm / ccd_mm;
end