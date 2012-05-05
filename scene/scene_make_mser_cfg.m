function cfg =  scene_make_mser_cfg(detector_cfg)
global CFG

if nargin < 1
    detector_cfg = CFG.detectors.extrema;
else
    tmp = detector_cfg;
    detector_cfg = CFG.detectors.extrema;
    detector_cfg = scene_cp_cfg_fields(tmp,detector_cfg);
end

cfg = scene_make_dr_cfg('mser',detector_cfg);