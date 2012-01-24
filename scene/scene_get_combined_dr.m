function [dr,img_id] = scene_get_combined_dr(img,detectors)
idx = 1;
dr = [];
for j = 1:numel(detectors)
    cfg = detectors{j};
    tp = cfg.detector.name;
    [dr.(tp),num_dr,img_id] = scene_get_dr(img,cfg,idx);
    dr.(tp).img_id = img_id;
    idx = idx+num_dr;
end