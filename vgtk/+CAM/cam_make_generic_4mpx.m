% make a 4 mexapixel camera
function [K nx ny ccd_sz f] = cam_make_4mpx(ef)
nx = 2240;
ny = 1680;
cc = [nx/2 ny/2];
alpha_c = 0;
ccd_sz = [5.76*10^-3 4.29*10^-3]; 
px_sz = ccd_sz./[nx ny];
s = cam_get_crop_factor(ccd_sz);
f = ef/s;
K = cam_make_K(f,cc,alpha_c,px_sz);