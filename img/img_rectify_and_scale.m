function timg = img_rectify_and_scale(img,H,T1)
if nargin < 3
    T1 = [];
end

nx = size(img,2);
ny = size(img,1);
border = [0.5    ny+0.5; ...
          0.5    0.5; ...
          nx+0.5 0.5];

if ~isempty(T1)
    T = maketform('composite',maketform('projective',H'),T1);
else
    T = maketform('projective',H');
end

tborder = tformfwd(T,border);

border = [border ones(3,1)]';
tborder = [tborder ones(3,1)]';

ss = laf_get_scale_from_3p([border(:) tborder(:)]);
s = sqrt(abs(ss(1)/ss(2)));

S = [10*s 0 0;
     0 10*s 0;
     0 0 1];

if ~isempty(T1)
    T = maketform('composite',T1, ...
                  maketform('projective',H'), ...
                  maketform('affine',S));
else
    T = maketform('composite', ...
                  maketform('projective',H'), ...
                  maketform('affine',S));
end

timg = imtransform(img,T,'bicubic','Fill', [255;255;255]);