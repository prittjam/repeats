function [dr,dhash] = dr_make_mser_cfg(dr_defs,varargin)
detectors = {'MSER+ inten.','MSER- inten.'};

extrema_cfg = set_extrema_defaults();
[extrema_cfg,leftover] = helpers.vl_argparse(extrema_cfg,varargin);

dhash = cfg2hash(extrema_cfg,1);

for k = 1:2 
    dr(k).name = detectors{k};
    dr(k).extrema_cfg = extrema_cfg;
    dr(k).dr_hash = dhash;
    dr(k).key = [dr(k).name ':' dr(k).dr_hash];
    dr(k).cache = 'On';
    [dr(k),leftover2] = helpers.vl_argparse(dr(k),leftover);
end 

function extrema = set_extrema_defaults()
extrema.verbose = 1;
extrema.relative = 0;
extrema.preprocess = 1;
extrema.export_image = 1;
extrema.min_size = 30;
extrema.min_margin = 10;
extrema.max_area = 0.01;
extrema.use_hyst_thresh = 0;
extrema.low_factor = 0.9;
extrema.precise_border = 0;
extrema.subsample_to_minsize = 0;
extrema.chroma_thresh = 0.09;
extrema.min_areadiff = 0.1;
extrema.nms_method = 0;