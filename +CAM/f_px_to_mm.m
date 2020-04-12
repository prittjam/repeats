function f_mm = f_px_to_mm(f_px, nx, ccd_mm)
    if nargin < 3
        ccd_mm = 36; % 36 mm equivalent
    end
    f_mm = f_px * ccd_mm / nx;
end