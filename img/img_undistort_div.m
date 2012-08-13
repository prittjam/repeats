function timg = img_undistort_div(img,cc,q)
L = cam_make_ld_div_tform(cc,q);

%nx = size(img,2);
%ny = size(img,1);
%border = [0.5    0.5; ...
%          nx+0.5 0.5; ...
%          nx+0.5 ny+0.5; ...
%          0.5    ny+0.5];
%tborder = tformfwd(L,border);

timg = imtransform(img,L,'bicubic','Fill', 0);