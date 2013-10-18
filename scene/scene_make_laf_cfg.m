function dr = scene_make_laf_cfg(dr,varargin)
global CFG DR

CFG.detectors.lafs = helpers.vl_argparse(CFG.detectors.lafs, ...
                                         varargin);

dhash = cfg2hash(CFG.detectors.lafs,1);

for k = 1:numel(dr)
    dr(k).upgrade = 'laf';
    dr(k).dhash = cvdb_hash_xor(dr(k).dhash,dhash);
end

upg_idx = scene_get_upgrade_ids(dr);
if numel(upg_idx) ~= numel(dr)
    error;
end






