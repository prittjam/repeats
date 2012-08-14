function [img_set,num_imgs] = scene_load_img_set(img_set)
for k = 1:numel(img_set)
    scene_load_img(img_set,k);
end
