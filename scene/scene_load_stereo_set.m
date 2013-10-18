function [stereo_set,num_imgs] = scene_load_stereo_set(stereo_set,im_fun)
if nargin < 2
    im_fun = [];
end

for k = 1:numel(stereo_set)
    stereo_set(k) = scene_load_stereo_pair(stereo_set(k));
end