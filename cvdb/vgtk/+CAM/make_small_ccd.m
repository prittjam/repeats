function [K nx ny cc ccd_sz f] = make_small_ccd(ef,nx,ny)
if nargin < 3
    nx = 960; 
    ny = 800;
end
cc = [nx/2 ny/2];
alpha_c = 0;
ccd_sz = [7.176*10^-3 5.319*10^-3]; 
px_sz = ccd_sz./[nx ny];
s = CAM.get_crop_factor(ccd_sz);
f = ef/s;
K = CAM.make_K(f,cc,alpha_c,px_sz);
