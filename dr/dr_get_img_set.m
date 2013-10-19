function dr = dr_get_img_set(dr_defs,img_set,detectors)
k = 1;
dr = cell(1,numel(img_set));
for img = img_set
    dr{k} = dr_get_img(dr_defs,detectors,img);
    k = k+1;              
end