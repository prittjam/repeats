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
                ids = num2cell([1:numel(feat{k}.affpt)]);
                [feat{k}.affpt(:).id] = deal(ids{:});
                [res{k}] = affpatch(img.intensity,feat{k}.affpt(~reflected_ind), ...
                                  KEY.class_to_struct(desc_cfg_list{k}));
                if ~isfield(res{k},'affpt')
                    res{k}.affpt = [];
                else
                    % res{k}.affpt_sift = res{k}.affpt;
                    desc = [res{k}.affpt(:).desc];
                    desc = mat2cell(desc,1,128*ones(numel(desc)/128,1));
                    res{k}.affpt = feat{k}.affpt([res{k}.affpt(:).id]);
                    [res{k}.affpt.desc] = deal(desc{:});
                    [res{k}.affpt.reflected] = deal(false);
                end
                if any(reflected_ind)
                    [temp] = affpatch(IMG.reflect(img.intensity),feat{k}.affpt(find(reflected_ind)), ...
                                  KEY.class_to_struct(desc_cfg_list{k}));
                    if isfield(temp,'affpt')
                        % temp.affpt_sift = temp.affpt;
                        desc = [temp.affpt(:).desc];
                        desc = mat2cell(desc,1,128*ones(numel(desc)/128,1));
                        temp.affpt = feat{k}.affpt([temp.affpt(:).id]);
                        [temp.affpt.desc] = deal(desc{:});
                        [temp.affpt.reflected] = deal(true);
                        RF = [-1 0 img.width; 0 1 0; 0 0 1];
                        temp.affpt = LAF.apply_T_to_affpt(temp.affpt,RF);
                        % res{k}.patch = [res{k}.patch temp.patch];
                        
                        res{k}.affpt = [res{k}.affpt temp.affpt];
                        % res{k}.affpt_sift = [res{k}.affpt_sift temp.affpt_sift];
                    end
                end 
                if ~isempty(res{k}.affpt)
                    ids = num2cell([1:numel(res{k}.affpt)]);
                    [res{k}.affpt(:).id_patch] = deal(ids{:});
                end
                res{k}.time = cputime-t;
                % res{k}.desc2dr = [res{k}.affpt(:).id];
                % res{k}.num_desc = length(res{k}.affpt);
            end
        end
    end
end