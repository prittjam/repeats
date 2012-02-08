function cfg =  scene_make_haff2_na_cfg(detector_cfg)
global CFG

if nargin < 1
    detector_cfg = CFG.detectors.affpts;
else
    CFG.detectors.affpts = detector_cfg;
end

cfg = scene_make_dr_cfg('haff2_na',detector_cfg);