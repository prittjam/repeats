classdef laf_factory < dr.dr_factory
    methods(Static)
        function laf_cfg = make(varargin)
            laf_cfg = dr.laf_cfg();
            [laf_cfg] = helpers.vl_argparse(laf_cfg,varargin);
            laf_cfg.key = cfg2hash(laf_cfg,true);
            laf_cfg.name = 'laf';
        end
    end
end