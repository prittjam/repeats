function [img_subset,ind] = find_img_subset(img_set,subset)
for k = 1:numel(subset)
    [img_subset{k},ind(k)] = find_img_name(img_set,subset{k});
end