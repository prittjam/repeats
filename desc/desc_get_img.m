function res = desc_get_img(desc_defs,descriptors,dr,img)
[res,is_found] = scene_get_desc(img.img_id,descriptors);
not_found = ~is_found;

if any(not_found)
    ind = find(not_found);
    res = desc_describe(desc_defs,descriptors,dr,img);
    %    scene_put_desc(img.img_id,descriptors,res(ind));
end
