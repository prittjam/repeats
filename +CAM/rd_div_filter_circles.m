function inliers = rd_div_filter_circles(c, img, outlierT)
    if nargin<3
        outlierT = 1e9;
    end

    flag_radius = c(3,:) > max(img.width, img.height) / 2;
    flag_distcenter = sqrt((img.width / 2 - c(1,:)).^2 +...
                        (img.height / 2 - c(2,:)).^2) < c(3,:);
    flag_rddiv = c(3,:).^2 -...
        ((img.width / 2 - c(1,:)).^2 -...
        (img.height / 2 - c(2,:)).^2) > 1./12;

    is_xgood = abs(c(1,:)) < outlierT;
    is_ygood = abs(c(2,:)) < outlierT;

    inliers = flag_radius & flag_distcenter & flag_rddiv & is_xgood & is_ygood;
end