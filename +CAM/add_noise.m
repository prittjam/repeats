function xn = add_noise(x,ccd_sigma)
N = size(x,2);
if (ccd_sigma > 0)
    xn = x+transpose(mvnrnd([0 0 0],diag([ccd_sigma ccd_sigma 0]),size(x,2)));
else 
    xn = x;
end
