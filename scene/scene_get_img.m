function [img,img_id] = scene_get_img(idx)
global DATA

img = DATA.imgs(idx).intensity;
img_id = DATA.imgs(idx).img_id;