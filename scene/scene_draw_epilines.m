function [] = scene_draw_epilines(icam,jcam,u,F)
global listing img_dir;
img_file_name1 = [img_dir listing(icam).name];
img_file_name2 = [img_dir listing(jcam).name];
im1 = imread(img_file_name1);
im2 = imread(img_file_name2);

figure;
eg_draw_epilines(u,F,im1,im2);
