function [cimg,img,img_id] = scene_load_img(img_set,j,im_fun)
global DATA
load_img(j,img_set(j).url);

if ~isempty(im_fun)
    DATA.imgs(j).data = feval(im_fun,DATA.imgs(j).data);
    DATA.imgs(j).intensity = rgb2gray(DATA.imgs(j).data);
end

cimg = DATA.imgs(j).data;
img = DATA.imgs(j).intensity;
img_id = cvdb_hash_img(img);
DATA.imgs(j).img_id = img_id;