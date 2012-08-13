function detector_cfg =  scene_make_laf_cfg(detector_cfg)
global CFG
tmp = detector_cfg;
detector_cfg = CFG.detectors.lafs;
detector_cfg = scene_cp_cfg_fields(tmp,detector_cfg);
CFG.detectors.lafs = detector_cfg;