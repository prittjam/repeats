function [dr,is_found,img_id] = scene_get_combined_dr(img_id,detectors)
dr = scene_construct_dr();
is_found = logical(numel(detectors));

gid = 1;
for j = 1:numel(detectors)
    cfg = detectors{j};
    tp = cfg.detector.name;
    [d,is_found(j),num_dr] = scene_get_dr(img_id,cfg,gid);
    if is_found(j)
        dr = cat(2,dr,d);
        gid = gid+num_dr;
    end
end