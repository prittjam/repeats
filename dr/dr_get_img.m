function res = dr_get_img(dr_defs,detectors,img)
[res,is_found] = scene_get_dr(img.img_id,detectors);
not_found = ~is_found;

if any(not_found)
    ind = find(not_found);
    res(ind) = dr_detect(dr_defs,detectors(not_found),img);
    res(ind) = dr_upgrade(dr_defs,detectors(not_found),res(ind), ...
                          img);
    scene_put_dr(img.img_id,detectors,res(ind));
end
