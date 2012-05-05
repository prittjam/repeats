function dr_set = scene_get_img_set_dr(detectors,disable_cache)
global chains DATA;

if nargin < 2
    disable_cache = 0;
end

make_img_idx = [];
dr_ids = [];
dr_set = {};

for img_idx = 1:numel(DATA.imgs)
    img_id = scene_get_img_id(img_idx);
    [dr,is_found] = scene_get_combined_dr(img_id, ...
                                          detectors);
    if is_found
        dr_set{img_idx} = dr;
    end

    ia = find(is_found == 0);

    if (disable_cache)
        ia = 1:numel(is_found);
    end

    if ~isempty(ia) 
        make_img_idx = unique(cat(2,make_img_idx,img_idx));
        for j = ia
            dr_ids = unique(cat(2,dr_ids,detectors{j}.subgenid));
        end
    end
end

chains = create_chains(make_img_idx,dr_ids);
dr_set = scene_make_dr(detectors,dr_set);