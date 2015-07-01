classdef dr_cache < handle
    properties
        image_cache
    end

    methods(Access = private)
        function key_list = add_cfg_list(this,cfg_list)
            for k = 1:numel(cfg_list)
                parents = '';
                for k1 = 1:numel(cfg_list{k})
                    name = [parents class(cfg_list{k}{k1})];
                    if isempty(parents)
                        this.image_cache.add_dependency(name, ...
                                                        cfg_list{k}{k1});
                    else
                        this.image_cache.add_dependency(name, ...
                                                        cfg_list{k}{k1}, ...
                                                        'parents',parents(1:end-1));
                    end
                    parents = [name ':'];
                end
                key_list{k} = name;
            end
        end

        function [res,is_found] = get(this,cfg_list)
            is_found = cell(1,numel(cfg_list));
            res = cell(1,numel(cfg_list));
            
            for k = 1:numel(cfg_list)
                name = '';
                res{k} = cell(1,numel(cfg_list{k}));
                is_found{k} = false(1,numel(cfg_list{k}));
                for k1 = 1:numel(cfg_list{k})
                    name = [name class(cfg_list{k}{k1}) ':'];
                    [res{k}{k1},is_found{k}(k1)] = ...
                        this.image_cache.get('dr',name(1:end-1));
                end
            end
        end
            
        function [res,is_found] = put(this,cfg_list,res)
            for k = 1:numel(cfg_list)
                name = '';
                for k1 = 1:numel(cfg_list{k})
                    name = [name class(cfg_list{k}{k1}) ':'];
                    this.image_cache.put('dr',name(1:end-1),res{k}{k1});
                end
            end
        end
    end
        
    methods 
        function this = dr_cache(image_cache)
            this.image_cache = image_cache;
        end

        function [feat,upg,desc,key_list] = extract(this,cfg_list,img)
            key_list = this.add_cfg_list(cfg_list);
            
            [res,is_found] = this.get(cfg_list);
            feat = res(:,1);
            upg = res(:,2);
            desc = res(:,3);

            putit = ~is_found(:,1);
            if any(putit)
                feat(putit) = DR.extract(cfg_list(putit,:),img);
                this.put(cfg_list(putit,:),feat(putit));
            end

            putit = ~is_found(:,2);
            isop = cellfun(@(x) ~strcmp(class(x),'DR.CFG.noop'),cfg_list(:,2));
            doit = isop & putit & cellfun(@(x) ~isempty(x),feat);
            upg(~isop) = feat(~isop);
            if any(doit)
                upg(doit) = ...
                    DR.upgrade(cfg_list(doit,:), ...
                               img,feat(doit));
                this.put(cfg_list(putit,:), ...
                         upg(putit));
            end
            
            cfg_list(~isop,2) = cfg_list(~isop,1);
            putit = ~is_found(:,3);
            doit = putit & cellfun(@(x) ~isempty(x),upg);
            if any(doit)
                desc(doit) = ...
                    DR.describe(cfg_list(doit,:), ...
                                img, upg(doit));
                this.put(cfg_list(putit,:),desc(putit));
            end
            keyboard
        end

        function [upg,key_list] = upgrade(this,upg_cfg_list,feat,img)
            key_list = this.add_cfg_list(upg_cfg_list);
            [upg,is_found] = this.get(upg_cfg_list);
            putit = ~is_found;
            doit = putit & cellfun(@(x) ~isempty(x),feat);
            if any(doit)
                upg(doit) = ...
                    DR.upgrade(upg_cfg_list(doit), ...
                               img,feat(doit));
                this.put(upg_cfg_list(putit), ...
                         upg(putit));
            end
        end

        function [desc,key_list] = describe(this,desc_cfg_list,upg,img)
            key_list = this.add_cfg_list(desc_cfg_list);
            [desc,is_found] = this.get(desc_cfg_list);
            putit = ~is_found;
            doit = putit & cellfun(@(x) ~isempty(x),upg);
            if any(doit)
                desc(doit) = ...
                    DR.describe(desc_cfg_list(doit), ...
                                img, upg(doit));
                this.put(desc_cfg_list(putit),desc(putit));
            end
        end
    end
end