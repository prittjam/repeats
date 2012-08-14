function m = scene_get_combined_tc(dr1,dr2,detectors)
m = [];

for k = 1:numel(detectors)
    cfg = detectors{k};
    tp = cfg.detector.name;
    m.(tp) = scene_get_tc(dr1.(tp), ...
                          dr2.(tp), ...
                          cfg);
end