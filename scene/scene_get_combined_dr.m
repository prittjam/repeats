function [dr,is_found,img_id] = scene_get_combined_dr(img,detectors)
idx = 1;

dr = [];
is_found = logical(size(detectors));

for j = 1:numel(detectors)
    cfg = detectors{j};
    tp = cfg.detector.name;
    [d,is_found(j),num_dr,img_id] = scene_get_dr(img,cfg,idx);
    dr = cat(2,dr,d);
    idx = idx+num_dr;
end