function laf_cfg =  scene_make_laf_cfg(laf_cfg_wbs)
global CFG

if nargin < 1
    laf_cfg.wbs = CFG.detectors.lafs;
else
    laf_cfg.wbs = scene_cp_cfg_fields(laf_cfg_wbs,CFG.detectors.lafs);
end

laf_cfg.dhash = cfg2hash(laf_cfg.wbs);