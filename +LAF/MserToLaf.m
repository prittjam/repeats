classdef MserToLaf < Gen
    methods
        function this = MserToLaf()
        end
    end
    
    methods(Static)
        function res = make(img,upg_cfg_list,mser_list)
            img = img.data;

            if size(img,3)==1
                img=img(:,:,[1,1,1]);
            end;

            res = cell(1,numel(upg_cfg_list));
            for k = 1:numel(upg_cfg_list)
                % get result and store it to appropriate field
                %t = cputime;

                [regs, affpts, cfg] = ...
                    mexlafs(img, {mser_list{k}.rle(:,~mser_list{k}.reflected)}, 0, ...
                            KEY.class_to_struct(upg_cfg_list{k}));
                
                affpts_ref = [];
                if any(mser_list{k}.reflected)
                    reflected_ind = find(mser_list{k}.reflected == 1);
                    [regs_ref, affpts_ref, cfg_ref] = ...
                    mexlafs(IMG.reflect(img), {mser_list{k}.rle(:,reflected_ind)}, 0, ...
                            KEY.class_to_struct(upg_cfg_list{k}));
                    ref = num2cell(reflected_ind([affpts_ref.id]));
                    [affpts_ref.id] = deal(ref{:});
                end
                affpts = [affpts; affpts_ref];
                %DR.data{imid, drid}.upgtime = cputime - t;

                upg = struct;
                % output map of upgrades to dr
                upg.upg2dr  = [affpts.id]';
                upg2dr = num2cell(upg.upg2dr);
                [affpts.upg2dr] = deal(upg2dr{:});

                reflected = num2cell(mser_list{k}.reflected(upg.upg2dr)');
                [affpts.reflected] = deal(reflected{:});

                % relabel upgraded regions
                for i=1:numel(affpts)
                    affpts(i).id=i;
                end
                
                upg.affpt = affpts;
                res{k} = upg;
            end
        end
    end
end