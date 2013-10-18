function dr_stereo_set = scene_get_stereo_set_dr(stereo_set, ...
                                                 detectors, ...
                                                 descriptor)
k = 1;
for pair = stereo_set
    dr_stereo_set{k} = scene_get_stereo_pair_dr(pair,detectors,descriptor);
    k = k+1;              
end

dr_ids = scene_get_dr_ids(work_detectors);
upg_ids = scene_get_upgrade_ids(work_detectors);

chains = create_chains(img_ids,dr_ids,TC.current,upg_ids);
dr_set = scene_make_dr(detectors,dr_set);