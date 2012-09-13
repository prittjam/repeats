function cfg = scene_make_tc_cfg(tc_cfg)
global CFG

cfg = struct;

if nargin < 1
    cfg.wbs = CFG.tc.sift;
else
    cfg.wbs = scene_cp_cfg_fields(tc_cfg,CFG.tc,sift);
end

CFG.tc.sift = cfg.wbs;

cfg.dhash = cfg2hash(cfg.wbs);