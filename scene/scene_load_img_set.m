function [img_set,num_imgs] = scene_load_img_set(img_set,im_fun)
if nargin < 2
    im_fun = [];
end

for k = 1:numel(img_set)
    scene_load_img(img_set,k,im_fun);
end