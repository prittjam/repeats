function xn = add_noise(x,ccd_sigma)
N = size(x,2);
if (ccd_sigma > 0)
    ccd_variance = ccd_sigma^2/2;
    xn = transpose(mvnrnd(x',diag([ccd_variance ccd_variance 0])));
else 
    xn = x;
end
