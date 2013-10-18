function dr_set = scene_get_img_set_dr(detectors,descriptor)
global CVDB_CACHE;

img_ids = [];
all_work = [];
dr_set = {};

for img_idx = 1:numel(DATA.imgs)
    img_id = scene_get_img_id(img_idx);
    is_found = zeros(1,numel(detectors));
    if (CVDB_CACHE.dr)
        [dr,is_found] = scene_get_combined_dr(img_id,detectors,descriptor);
    end
    do_work = find(is_found == 0);
    if numel(do_work) > 0
        img_ids = unique(cat(2,img_ids,img_idx));
        all_work = unique(cat(2,all_work,do_work));
    end
end

work_detectors = detectors(all_work);

dr_ids = scene_get_dr_ids(work_detectors);
upg_ids = scene_get_upgrade_ids(work_detectors);

chains = create_chains(img_ids,dr_ids,TC.current,upg_ids);
dr_set = scene_make_dr(detectors,dr_set);