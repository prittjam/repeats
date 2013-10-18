function [img_set,num_imgs] = scene_load_img_set(img_set,im_fun)
if nargin < 2
    im_fun = [];
end

for k = 1:numel(img_set)
    img = scene_load_img(img_set(k));
    img_set(k).data = img.data;
    img_set(k).intensity = img.intensity;
    img_set(k).img_id = img.img_id;
end