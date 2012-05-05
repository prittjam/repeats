function [cimg,img,img_id] = scene_load_img(img_set,j)
global DATA
load_img(j,img_set(j).url);
cimg = DATA.imgs(j).data;
img = DATA.imgs(j).intensity;
img_id = cvdb_hash_img(img);
DATA.imgs(j).img_id = img_id;