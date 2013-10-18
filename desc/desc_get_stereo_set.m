function res = desc_get_stereo_set(desc_defs,stereo_set,descriptors,dr)
k = 1;
res = cell(2,numel(stereo_set));
for pair = stereo_set
    res(1:2,k) = desc_get_stereo_pair(desc_defs,pair,descriptors,dr(:,k));
    k = k+1;              
end