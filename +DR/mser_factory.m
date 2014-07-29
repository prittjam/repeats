classdef mser_factory < dr.dr_factory
    methods(Static)
        function mser_cfg = make(varargin)
            mser_cfg = dr.mser_cfg();
            [mser_cfg] = helpers.vl_argparse(mser_cfg,varargin);
            mser_cfg.key = cfg2hash(mser_cfg,true);
        end
    end
end