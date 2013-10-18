function cfg =  scene_make_haff2_na_cfg(detector_cfg,varargin)
global CFG

p = inputParser;

p.addParamValue('sift',scene_make_sift_cfg([],@sift_calc_rootSIFT),@isstruct);
p.addParamValue('lafs',scene_make_laf_cfg(),@isstruct);
p.parse(varargin{:});

CFG.descs.sift = p.Results.sift.wbs;
CFG.detectors.lafs = p.Results.lafs.wbs;

cfg.detector.name = 'haff2_na';
cfg.sift = p.Results.sift;
cfg.lafs = p.Results.lafs;

if isempty(detector_cfg)
    cfg.wbs = CFG.detectors.affpts;
else
    cfg.wbs = scene_cp_cfg_fields(detector_cfg,CFG.detectors.affpts);
end

CFG.detectors.affpts = cfg.wbs;
cfg.wbs = cfg.wbs;

cfg.subgenid = 7;
cfg.output_format = 2;
cfg.upgrade = 0;
scene_update_wbsdr(cfg.subgenid,cfg.upgrade);

% hash for detector/descriptor configuration
dhash = cfg2hash(cfg.wbs,1);
cfg.dhash = cvdb_hash_xor(dhash, ...
                          cvdb_hash_xor(cfg.lafs.dhash,cfg.sift.dhash));