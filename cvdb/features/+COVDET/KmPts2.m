classdef KmPts2 < Gen
    methods
        function this = KmPts2()
        end
    end
    
    methods(Static)
        function res = make(img,feat_cfg_list,varargin)
            disp(['AFFPT detection ' img.url]);                
            res = cell(1,numel(feat_cfg_list));
            for k = 1:numel(feat_cfg_list)
                res{k} = kmpts2(img.data, ...
                                KEY.class_to_struct(feat_cfg_list{k}));
                res{k}.haff = 1;
            end
        end
    end
end