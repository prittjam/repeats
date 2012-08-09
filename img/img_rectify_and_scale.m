function timg = img_rectify_and_scale(img,T1)
nx = size(img,2);
ny = size(img,1);
border = [0.5    ny+0.5; ...
          0.5    0.5; ...
          nx+0.5 0.5];
xborder = tformfwd(T,border);

border = [border ones(3,1)]';
xborder = [xborder ones(3,1)]';

ss = laf_get_scale_from_3p([border(:) xborder(:)]);
s = ss(1)/ss(2);

S = [s 0 0;
     0 s 0;
     0 0 1];
T2 = maketform('affine',S);
T = maketform('composite',T1,T2);

timg = imtransform(img,T,'bicubic','Fill', 0);