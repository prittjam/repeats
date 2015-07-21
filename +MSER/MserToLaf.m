classdef MserToLaf < DR.Gen
    methods
        function this = MserToLaf()
        end

        function res = make(this,img,upg_cfg_list,mser_list)
            img = img.data;

            if size(img,3)==1
                img=img(:,:,[1,1,1]);
            end;

            res = cell(1,numel(upg_cfg_list));
            for k = 1:numel(upg_cfg_list)
                % get result and store it to appropriate field
                %t = cputime;

                [regs, affpts, cfg] = mexlafs(img, {mser_list{k}.rle}, 0, ...
                                              DR ...
                                              .make_struct(upg_cfg_list{k}));
                kkk = 3;
                %DR.data{imid, drid}.upgtime = cputime - t;

                upg = struct;
                % output map of upgrades to dr
                upg.upg2dr  = [affpts.id];

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