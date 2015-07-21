classdef DrCache < handle
    properties
        image_cache
    end

    methods(Access = private)
        function key_list = add_cfg_list(this,cfg_list)
            key_list = cell(1,numel(cfg_list));
            for k = 1:numel(cfg_list)
                key_list{k} = cell(1,numel(cfg_list{k}));
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
                    key_list{k}{k1} = name;
                end
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
        function this = DrCache(image_cache)
            this.image_cache = image_cache;
        end

        function [res,key_list] = extract(this,cfg_list,img)
            key_list = this.add_cfg_list(cfg_list);
            
            [res,is_found] = this.get(cfg_list);

            putit = cellfun(@(x) any(cellfun(@(y) isempty(y),x)),res);
            if any(putit)
                res(putit) = DR.extract(cfg_list(putit),img);
                this.put(cfg_list(putit),res(putit));
            end
        end

    end
end