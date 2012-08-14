function [img_set,num_imgs] = scene_get_img_set(img_set_name)
global conn;
img_set = cvdb_sel_img_set(conn, img_set_name);
num_imgs = numel(img_set);
