function desc = desc_make_sift_cfg(defs,dr,upg_list,varargin)
sift_cfg = make_default_sift_cfg(varargin{:});

descriptor = struct;
descriptor.cfg = sift_cfg;
descriptor.key = cfg2hash(descriptor.cfg,true);

final_representations = dr_get_final_representations(defs.dr,dr,upg_list);
descriptor.fqname = dr_get_fqnames(

desc_key = [];
for k = 1:numel(dr)
    desc_def = desc_find(defs.desc,final_representations(k), ...
                         {'sift'});
    descriptor.name = desc_def.name;

    descriptor.read_cache = 'On';
    descriptor.write_cache = 'On';

    [descriptor,~] = helpers.vl_argparse(descriptor,varargin{:});

    desc(k) = descriptor;
end
    
function sift_cfg =  make_default_sift_cfg(varargin)
% SIFT description params
sift_cfg = [];
sift_cfg.ignore_gradient_sign = 0;
sift_cfg.desc_factor = 3*sqrt(3);
sift_cfg.verbose = 1;
sift_cfg.patch_size = 41;
sift_cfg.compute_descriptor = 1;
sift_cfg.output_format= 2;
[sift_cfg,~] = helpers.vl_argparse(sift_cfg,varargin{:});