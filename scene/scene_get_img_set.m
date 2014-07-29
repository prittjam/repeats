function [img_set,num_imgs] = scene_get_img_set(cvdb,img_set_name)
img_set = cvdb_sel_img_set(cvdb,img_set_name);
num_imgs = numel(img_set);
