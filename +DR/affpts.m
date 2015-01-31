classdef affpts < DR.gen
    properties
        subids;
    end

    methods
        function this = affpts()
        end

        function res = extract_features(this,img,feat_cfg_list)
            disp(['AFFPTS detection ' img.url]);
            res = cell(1,numel(feat_cfg_list));
            for k = 1:numel(feat_cfg_list)
                res{k} = kmpts2(img.data, ...
                                DR.make_struct(feat_cfg_list(k)));
            end
        end
    end
end
