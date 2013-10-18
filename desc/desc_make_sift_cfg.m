function descriptor = desc_make_sift_cfg(varargin)
sift_cfg = make_default_sift_cfg();
[sift_cfg,leftover] = helpers.vl_argparse(sift_cfg,varargin{:});

descriptor = struct;
descriptor.sift_cfg = sift_cfg;
descriptor.normalize = @(x) double(x);
descriptor.name = 'sift';
descriptor.dhash = cfg2hash(descriptor.sift_cfg,1);
descriptor = helpers.vl_argparse(descriptor,leftover);

function sift_cfg =  make_default_sift_cfg()
% SIFT description params
sift_cfg = [];
sift_cfg.ignore_gradient_sign = 0;
sift_cfg.desc_factor = 3*sqrt(3);
sift_cfg.verbose = 1;
sift_cfg.patch_size = 41;
sift_cfg.compute_descriptor = 1;
sift_cfg.output_format = 2;