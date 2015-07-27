classdef LafToDistinctLaf < DR.Gen
    properties
        distinct_cfg = LAF.CFG.Distinct();
    end

    methods
        function this = LafDistinct()
        end

        function res = make(this,img,cfg_list,laf_list,varargin)
            disp(['DISTINCT regions ' img.url]);                
            res = cell(1,numel(cfg_list));
            for k = 1:numel(cfg_list)
                keepind = LAF.get_distinct(this.distinct_cfg, ...
                                           laf_list{k}.affpt);
                res{k}.affpt = laf_list{k}.affpt(keepind);
            end
        end
    end
end
