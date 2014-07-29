function dr = dr_get_img_set(dr_defs,img_set,detectors,upgrades,img_cache)
k = 1;
dr = cell(1,numel(img_set));
for img = img_set
    dr{k} = dr_get_img(dr_defs,detectors,upgrades,img,img_cache);
    k = k+1;              
end