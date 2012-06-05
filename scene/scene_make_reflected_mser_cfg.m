function cfg =  scene_make_reflected_mser_cfg(detector_cfg)
global CFG

if nargin < 1
    detector_cfg = CFG.detectors.extrema;
else
    CFG.detectors.extrema = detector_cfg;
end

cfg = scene_make_dr_cfg('mser',detector_cfg);


%safe_assign('CFG.detectors.lafs.lafConstructsToUse_LAF__LAF_CG_CURV_MIN', 0);
