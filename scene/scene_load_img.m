function [img,intensity] = scene_load_img(img_set,i)
global DATA
load_img(i,img_set(i).url);
img = DATA.imgs(i).data;
intensity = DATA.imgs(i).intensity;