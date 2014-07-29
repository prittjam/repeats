function dr = dr_make_mser_cfg(dr_defs,varargin)
detectors = {'MSERp','MSERm'};

for k = 1:2 
    dr(k).name = detectors{k};
    dr(k).cfg = set_extrema_defaults(varargin);
    dr(k).key = cfg2hash(dr(k).cfg,true);

    dr(k).read_cache = 'On';
    dr(k).write_cache = 'On';

    [dr(k),leftover] = helpers.vl_argparse(dr(k),varargin{:});
end 

function [extrema_cfg] = set_extrema_defaults(varargin)
extrema_cfg.verbose = 1;
extrema_cfg.relative = 0;
extrema_cfg.preprocess = 1;
extrema_cfg.export_image = 1;
extrema_cfg.min_size = 30;
extrema_cfg.min_margin = 10;
extrema_cfg.max_area = 0.01;
extrema_cfg.use_hyst_thresh = 0;
extrema_cfg.low_factor = 0.9;
extrema_cfg.precise_border = 0;
extrema_cfg.subsample_to_minsize = 0;
extrema_cfg.chroma_thresh = 0.09;
extrema_cfg.min_areadiff = 0.1;
extrema_cfg.nms_method = 0;

[extrema_cfg,leftover] = helpers.vl_argparse(extrema_cfg,varargin{:});