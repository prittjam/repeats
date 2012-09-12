function cfg = scene_make_mser_cfg(detector_cfg,varargin)
global CFG

p = inputParser;

p.addParamValue('sift',scene_make_sift_cfg([],@sift_calc_rootSIFT),@isstruct);
p.addParamValue('lafs',scene_make_laf_cfg(),@isstruct);
p.parse(varargin{:});

CFG.descs.sift = p.Results.sift.wbs;
CFG.detectors.lafs = p.Results.lafs.wbs;

cfg.detector.name = 'mser';

cfg.lafs = p.Results.lafs;
cfg.sift = p.Results.sift;

if isempty(detector_cfg)
    detector_cfg = CFG.detectors.extrema;
else
    detector_cfg = scene_cp_cfg_fields(detector_cfg,CFG.detectors.extrema);
end

CFG.detectors.extrema = detector_cfg;

cfg.subtype.tbl = {'intp', 'intm'};    
cfg.subtype.id  = [1 2];    
cfg.subgenid    = [1 2];
cfg.upgrade     = [2 2];
scene_update_wbsdr(cfg.subgenid,cfg.upgrade);

dhash = cfg2hash(detector_cfg);
cfg.dhash = cvdb_hash_xor(dhash, ...
                          cvdb_hash_xor(cfg.lafs.dhash,cfg.sift.dhash));

cfg = scene_make_dr_cfg(cfg);