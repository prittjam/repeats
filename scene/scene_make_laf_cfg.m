function laf_cfg =  scene_make_laf_cfg(laf_cfg)
global CFG
tmp = laf_cfg;
laf_cfg = CFG.detectors.lafs;
laf_cfg = scene_cp_cfg_fields(tmp,laf_cfg);
CFG.detectors.lafs = laf_cfg;