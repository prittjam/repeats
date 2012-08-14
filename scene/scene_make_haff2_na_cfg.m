function cfg =  scene_make_haff2_na_cfg(detector_cfg,sift_cfg)
global CFG

if isempty(detector_cfg)
    detector_cfg = CFG.detectors.affpts;
else
    tmp = detector_cfg;
    detector_cfg = CFG.detectors.affpts;
    detector_cfg = scene_cp_cfg_fields(tmp,detector_cfg);
end

if isempty(sift_cfg)
    sift_cfg = scene_make_sift_cfg();
end

cfg = scene_make_dr_cfg('haff2_na',detector_cfg,sift_cfg);