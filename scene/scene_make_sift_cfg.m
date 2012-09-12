function sift_cfg = scene_make_sift_cfg(sift_cfg_wbs,normalize)
global CFG

if isempty(sift_cfg_wbs)
    sift_cfg.wbs = CFG.descs.sift;
else
    sift_cfg.wbs = scene_cp_cfg_fields(sift_cfg_wbs,CFG.descs.sift);
end

if nargin < 2
    sift_cfg.normalize = @(x) x;
else
    sift_cfg.normalize = normalize;
end

sift_cfg.dhash = cfg2hash(sift_cfg.wbs);