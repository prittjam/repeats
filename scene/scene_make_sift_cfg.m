function descriptor = scene_make_sift_cfg(varargin)
global CFG

[CFG.descs.sift,leftover] = helpers.vl_argparse(CFG.descs.sift,varargin{:});

descriptor = struct;
descriptor.normalize = @(x) double(x);
descriptor.name = 'sift';
descriptor.dhash = cfg2hash(CFG.descs.sift,1);
descriptor = helpers.vl_argparse(descriptor,leftover);