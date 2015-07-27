classdef Affpts < DR.Gen
    properties
        subids;
    end

    methods
        function this = Affpts()
        end

        function res = make(this,img,feat_cfg_list,varargin)
            disp(['AFFPTS detection ' img.url]);                
            res = cell(1,numel(feat_cfg_list));
            for k = 1:numel(feat_cfg_list)
                res{k} = kmpts2(img.data, ...
                                KEY.class_to_struct(feat_cfg_list{k}));
            end
        end
    end
end
