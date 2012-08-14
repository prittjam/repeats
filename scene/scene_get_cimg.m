function [img,img_id] = scene_get_cimg(img_idx)
global DATA
img = DATA.imgs(img_idx).data;
img_id = DATA.imgs(img_idx).img_id;