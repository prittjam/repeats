function [data,intensity,img_id] = scene_load_img(img,im_fun)
data = imread(img.url);
intensity = rgb2gray(data);
img_id = cvdb_hash_img(data);