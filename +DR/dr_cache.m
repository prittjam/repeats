classdef dr_cache < handle
    properties
        image_cache
    end

    methods 
        function this = dr_cache(image_cache)
            this.image_cache = image_cache;
        end

        function [] = init(this,feat_cfg_list,upg_cfg_list,desc_cfg_list)
            cfg_list = [feat_cfg_list,upg_cfg_list,desc_cfg_list];
            if ~isempty(cfg_list)
                for k = 1:numel(cfg_list)
                    if isempty(cfg_list(k).prev)
                        this.image_cache.add_dependency(cfg_list(k).name, ...
                                                        cfg_list(k));
                    else
                        this.image_cache.add_dependency(cfg_list(k).name, ...
                                                        cfg_list(k), ...
                                                        'parents',cfg_list(k).prev.name);
                    end
                end
            end
            parent_list = arrayfun(@(x) x.name,desc_cfg_list, ...
                                   'UniformOutput',false);
            this.image_cache.add_dependency('dr',[], ...
                                            'parents',parent_list);
        end
        
        function [res,is_found] = get(this,cfg_list)
            is_found = false(1,numel(cfg_list));
            res = cell(1,numel(cfg_list));

            for k = 1:numel(cfg_list)
                [res{k},is_found(k)] = ...
                    this.image_cache.get('dr',cfg_list(k).name);
            end
        end
            
        function [res,is_found] = put(this,cfg_list,res)
            for k = 1:numel(cfg_list)
                key = DR.make_key(cfg_list(k));
                this.image_cache.put('dr',cfg_list(k).name,res{k});
            end
        end

        function feat = extract(this,feat_cfg_list,img)
            [feat,is_found] = this.get(feat_cfg_list);
            not_found = ~is_found;
            if any(not_found)
                feat(not_found) = DR.extract(feat_cfg_list(not_found),img);
                this.put(feat_cfg_list(not_found),feat(not_found));
            end
        end

        function upg = upgrade(this,upg_cfg_list,feat,img)
            [upg,is_found] = this.get(upg_cfg_list);
            not_found = ~is_found;
            if any(not_found)
                upg(not_found) = DR.upgrade(upg_cfg_list(not_found),img,feat);
                this.put(upg_cfg_list(not_found),upg(not_found));
            end
        end

        function desc = describe(this,desc_cfg_list,upg,img)
            [desc,is_found] = this.get(desc_cfg_list);
            not_found = ~is_found;
            if any(not_found)
                desc(not_found) = DR.describe(desc_cfg_list,img,upg);
                this.put(desc_cfg_list,desc(not_found));
            end
        end

    end
end