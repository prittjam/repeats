classdef AffPtToSift < handle & matlab.mixin.Heterogeneous
    methods
        function this = AffPtToSift()
        end
    end
    
    methods(Static)
        function res = make(img,desc_cfg_list,feat)
            for k = 1:numel(desc_cfg_list)
                %            msg(1, 'Generating ''%s'' desc. from ''%s'' (%s)\n', ...
                %                upper(outputs{k}),dr{k}.name,img.url);
                t = cputime;
                res{k} = affpatch(img.intensity,feat{k}.affpt(~[feat{k}.affpt.reflected]), ...
                                  KEY.class_to_struct(desc_cfg_list{k}));
                [res{k}.affpt.reflected] = deal(false);
                reflected_ind = find([feat{k}.affpt.reflected]);
                if ~isempty(reflected_ind)
                    temp = affpatch(IMG.reflect(img.intensity),feat{k}.affpt(reflected_ind), ...
                                  KEY.class_to_struct(desc_cfg_list{k}));
                    [temp.affpt.reflected] = deal(true);
                    RF = [-1 0 img.width; 0 1 0; 0 0 1];
                    temp.affpt = LAF.apply_T_to_affpt(temp.affpt,RF);
                    res{k}.affpt = [res{k}.affpt temp.affpt];
                end    
                res{k}.time = cputime-t;
                
                % res{k}.desc2dr = [res{k}.affpt(:).id];
                % res{k}.num_desc = length(res{k}.affpt);
            end
        end
    end
end