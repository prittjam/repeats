function [cimg,img,img_id] = scene_load_stereo_pair(stereo_set,j)
global DATA

k = 2*(j-1)+1;
load_img(k,stereo_set(j).img1.url);

cimg = DATA.imgs(k).data;
img = DATA.imgs(k).intensity;
img_id = cvdb_hash_img(img);
DATA.imgs(k).img_id = img_id;

k = k+1;
load_img(k,stereo_set(j).img2.url);

cimg = DATA.imgs(k).data;
img = DATA.imgs(k).intensity;
img_id = cvdb_hash_img(img);
DATA.imgs(k).img_id = img_id;