classdef ImageCache < handle
    properties(Access=private)
        G;
        cid;
        imagedb;
        vlist;
        map;
        last_add;
        cfg;
    end

    methods(Access=public)
        function this = ImageCache(cid,imagedb,varargin)
            this.imagedb = imagedb;
            this.cid = cid;
            this.map = containers.Map;
            this.vlist = cell(1,1000);
            this.G = [];
            last_add = {};
            
            this.cfg.read_cache = true;
            this.cfg.write_cache = true;

            [this.cfg,~] = helpers.vl_argparse(this.cfg,varargin);
            
            if isempty(cid)
                this.cfg.read_cache = false;
                this.cfg.write_cache = false;
            end
        end 

        function xor_key = add_dependency(this,name,key,varargin)
            cfg.parents = {}; 
            
            key = DR.make_key(key);
            
            cfg = helpers.vl_argparse(cfg,varargin);
	    
	    if ~isempty(cfg.parents) && ~iscell(cfg.parents)
                cfg.parents = {cfg.parents};
     end
	    
            if strcmpi([cfg.parents{:}],'__LAST_ADD__')
                cfg.parents = last_add;
            end

            v = this.add_vertex(name,key,cfg.parents{:});
            xor_key = this.get_xor_key(v);
            last_add = name;
        end

        function xor_key_list = add_dependency_list(this,name_list, ...
                                                    key_list,varargin)
          cfg.parents = {}; 
            
            if isempty(key)
                key = repmat('0',1,32);
            end

            cfg = helpers.vl_argparse(cfg,varargin);

	    if ~iscell(cfg.parents)
	      cfg.parents = {cfg.parents};
	    end

            if strcmpi([cfg.parents{:}],'__LAST_ADD__')
                cfg.parents = last_add;
            end

            for k = 1:numel(name_list)
                v = this.add_vertex(name,key,cfg.parents{:});
                xor_key_list{k} = this.get_xor_key(v);
            end

            last_add = name_list;
        end
        
        function img = get_img(this)
            img = this.imagedb.get_img(this.cid);
        end

        function [is_put,xor_key] = put(this,table,name,value,varargin)
            cfg.overwrite = false;
            cfg = helpers.vl_argparse(cfg,varargin);

            is_put = false;
            
            if this.map.isKey(name)
                item = this.map(name);
                v = item.v;
                xor_key = this.get_xor_key(v);
                
                if this.cfg.write_cache 
                    if ((~this.imagedb.check(table,this.cid,xor_key) | ...
                         cfg.overwrite))
                        this.imagedb.put(table,this.cid, ...
                                         [name ':' xor_key],value);
                        is_put = true;
                    else
                        error('Cannot put');
                    end
                end
            end
        end

        function [val,is_found,xor_key] = get(this,table,name)
            val = [];
            xor_key = [];
            is_found = false;
            if this.map.isKey(name)
                item = this.map(name);
                v = item.v;
                xor_key = this.get_xor_key(v);
                if this.cfg.read_cache
                    [val,is_found] = this.imagedb.get(table, ...
                                                      this.cid,[name ':' xor_key]);        
                end    
            end
        end
    end

    methods(Access=private) 
        function res = get_key(this,name)
            item = this.map(name);
            res = item.key;
        end

        function res = get_xor_key(this,v)
            [~,dt] = bfs(this.G,v);
            tmp = v;
            ia = v;
            [val,order] = sort(dt);
            order = order(val > 0);
            key_list = cellfun(@(x) x.key, ...
                               values(this.map,this.vlist(order)), ...
                               'UniformOutput',false);
            if numel(key_list) > 1
                res = HASH.xor(key_list{:});
            else
                res = key_list{1};
            end
        end
        
        function v = add_vertex(this,name,key,varargin)
            [ii,jj] = find(this.G);
            this.G = sparse(ii,jj,ones(1,numel(jj)), ...
                           num_vertices(this.G)+1, ...
                           num_vertices(this.G)+1); 
            if num_vertices(this.G) > 1            
                for pa = varargin
                    item = this.map(pa{:});
                    this.G(num_vertices(this.G),item.v) = 1;
                end
            end
            v = num_vertices(this.G);
            item = struct('v',v, ...
                          'key',key);
            uid = name;
            this.map(uid) = item;
            this.vlist{v} = uid;
        end

        function [] = remove_vertex(this,v)
            p = dfs(this.G);
            this.G(:,p) = [];
            this.G(p,:) = [];
            remove(this.map,vlist(p));
        end
    end
end