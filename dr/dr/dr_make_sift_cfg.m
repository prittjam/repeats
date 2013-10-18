function desc = dr_make_sift_cfg(defs,dr,varargin)
sift_cfg = make_default_sift_cfg();
[sift_cfg,leftover] = helpers.vl_argparse(sift_cfg,varargin{:});

descriptor = struct;
descriptor.sift_cfg = sift_cfg;
descriptor.normalize = @(x) double(x);
descriptor.desc_hash = cfg2hash(descriptor.sift_cfg,1);
descriptor.cache = 'On';
descriptor = helpers.vl_argparse(descriptor,leftover);

final_representations = dr_get_final_representations(defs.dr,dr);

for k = 1:numel(dr)
    desc_def = desc_find(defs.desc,final_representations(k), ...
                         {'sift'});
    descriptor.name = desc_def.name;
    descriptor.key = [dr(k).key ':' descriptor.name ':' descriptor.desc_hash];
    desc(k) = descriptor;
    [desc(k),leftover2] = helpers.vl_argparse(desc(k),leftover{:});
end
    
function sift_cfg =  make_default_sift_cfg()
% SIFT description params
sift_cfg = [];
sift_cfg.ignore_gradient_sign = 0;
sift_cfg.desc_factor = 3*sqrt(3);
sift_cfg.verbose = 1;
sift_cfg.patch_size = 41;
sift_cfg.compute_descriptor = 1;
sift_cfg.output_format= 2;