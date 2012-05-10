% make a 4 mexapixel camera
function [K nx ny] = cam_make_4mpx(f)
nx = 2240;
ny = 1680;
cc = [nx/2 ny/2];
alpha_c = 0;
ccd_sz = [7.18*10^-3 5.32*10^-3]; 
px_sz = ccd_sz./[nx ny];

K = cam_make_K(f,cc,alpha_c,px_sz);