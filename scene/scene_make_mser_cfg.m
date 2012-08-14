function cfg =  scene_make_mser_cfg(detector_cfg,sift_cfg)
global CFG

if isempty(detector_cfg)
    detector_cfg = CFG.detectors.extrema;
else
    tmp = detector_cfg;
    detector_cfg = CFG.detectors.extrema;
    detector_cfg = scene_cp_cfg_fields(tmp,detector_cfg);
end

if isempty(sift_cfg)
    sift_cfg = scene_make_sift_cfg();
end

cfg = scene_make_dr_cfg('mser',detector_cfg,sift_cfg);