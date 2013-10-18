function img = scene_load_img(img,im_fun)
if nargin < 2
    im_fun = [];
end
if isempty(im_fun)
    img.data = imread(img.url);
else
    img.data = feval(im_fun,imread(img.url));
end
img.intensity = rgb2gray(img.data);
img.img_id = cvdb_hash_img(img.data);