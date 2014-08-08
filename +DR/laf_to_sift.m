classdef laf_to_sift < handle & matlab.mixin.Heterogeneous
    methods
        function this = laf_to_sift()
        end

        function res = describe_features(this,img,feat,desc_cfg_list)
            for k = 1:numel(desc_cfg_list)
                %            msg(1, 'Generating ''%s'' desc. from ''%s'' (%s)\n', ...
                %                upper(outputs{k}),dr{k}.name,img.url);
                t = cputime;
                res{k} = affpatch(img.intensity,feat{k}.affpt, ...
                                  DR.make_struct(desc_cfg_list(k)));
                res{k}.time = cputime-t;
                res{k}.desc2dr = [res{k}.affpt(:).id];
                res{k}.num_desc = length(res{k}.affpt);
            end
        end
    end
end