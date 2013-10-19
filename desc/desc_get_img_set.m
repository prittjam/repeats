function res = desc_get_img_set(desc_defs,img_set,descriptors,dr)
k = 1;
res = cell(1,numel(img_set));
for img = img_set
    res{k} = desc_get_img(desc_defs,descriptors,dr{k},img);
    k = k+1;              
end