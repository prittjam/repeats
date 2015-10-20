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
                reflected_ind = ([feat{k}.affpt.reflected]);
                res{k} = affpatch(img.intensity,feat{k}.affpt(~reflected_ind), ...
                                  KEY.class_to_struct(desc_cfg_list{k}));
                desc = [res{k}.affpt(:).desc];
                desc = mat2cell(desc,1,128*ones(numel(desc)/128,1));
                res{k}.affpt = feat{k}.affpt([res{k}.affpt(:).id])';
                [res{k}.affpt.desc] = deal(desc{:});
                [res{k}.affpt.reflected] = deal(false);

                if any(reflected_ind)
                    temp = affpatch(IMG.reflect(img.intensity),feat{k}.affpt(find(reflected_ind)), ...
                                  KEY.class_to_struct(desc_cfg_list{k}));
                    desc = [temp.affpt(:).desc];
                    desc = mat2cell(desc,1,128*ones(numel(desc)/128,1));
                    temp.affpt = feat{k}.affpt([temp.affpt(:).id])';
                    [temp.affpt.desc] = deal(desc{:});
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