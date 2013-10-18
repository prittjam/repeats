function [dr,dhash] = scene_make_mser_cfg(varargin)
global DR CFG

detectors = {'MSER+ inten.','MSER- inten.'};
CFG.detectors.extrema = helpers.vl_argparse(CFG.detectors.extrema, ...
                                            varargin);
DR.current = unique([DR.current drname2id(detectors)]);

dr(1).name = detectors{1};
dr(2).name = detectors{2};

dhash = cfg2hash(CFG.detectors.extrema,1);

dr(1).dhash = dhash;
dr(2).dhash = dhash;