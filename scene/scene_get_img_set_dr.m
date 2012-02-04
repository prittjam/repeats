function dr = scene_get_img_set_dr(img_set,detectors)

global chains;
num_cams = numel(img_set);

img_ids = [];
dr_ids = [];

for i = 1:num_cams
    [img,intensity] = scene_load_img(img_set,i);
    is_found = [];
    [dr{i},is_found,img_id] = scene_get_combined_dr(intensity,detectors);
    ia = find(is_found == 0);
    if ~isempty(ia)
        img_ids = unique(cat(2,img_ids,i));
        for j = ia
            dr_ids = unique(cat(2,dr_ids,detectors{j}.subgenid));
        end
    end
end

chains = create_chains(img_ids,dr_ids);
dr = scene_make_dr(detectors,dr);