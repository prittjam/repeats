classdef CidCache < handle
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
        function this = CidCache(cid,imagedb,varargin)
            this.imagedb = imagedb;
            this.cid = cid;
            this.map = containers.Map;
            this.vlist = cell(1,1000);
            this.G = [];
            last_add = {};
            
            this.cfg.read_cache = true;
            this.cfg.write_cache = true;

            [this.cfg,~] = cmp_argparse(this.cfg,varargin);
            
            if isempty(cid) || isempty(imagedb)
                this.cfg.read_cache = false;
                this.cfg.write_cache = false;
            end
        end 

        function xor_key = add_dependency(this,name,key,varargin)
            cfg.parents = {}; 
            
            key = KEY.make(key);

            % key = KEY.make(key,name);
            
            cfg = cmp_argparse(cfg,varargin);
	    
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

        function key_list = add_chains(this,chains)
            key_list = cell(1,numel(chains));
            for k = 1:numel(chains)
                key_list{k} = cell(1,numel(chains{k}));
                parents = '';
                for k1 = 1:numel(chains{k})
                    name = [parents chains{k}{k1}.get_uname()];
                    if isempty(parents)
                        this.add_dependency(name, ...
                                                 chains{k}{k1});
                    else
                        this.add_dependency(name, ...
                                                 chains{k}{k1}, ...
                                                 'parents',parents(1:end-1));
                    end
                    parents = [name ':'];
                    key_list{k}{k1} = name;
                end
            end
        end
        
        function [res,is_found] = get_chains(this,chains)
            is_found = cell(1,numel(chains));
            res = cell(numel(chains),1);
            
            for k = 1:numel(chains)
                name = '';
                res{k} = cell(1,numel(chains{k}));
                is_found{k} = false(1,numel(chains{k}));
                for k1 = 1:numel(chains{k})
                    name = [name chains{k}{k1}.get_uname() ':'];
                    [res{k}{k1},is_found{k}(k1)] = ...
                        this.get('dr',name(1:end-1));
                    if is_found{k}(k1) && isstruct(res{k}{k1}) && isfield(res{k}{k1},'Data')
                        res{k}{k1} = CompressLib.decompress(res{k}{k1});
                    end
                end
            end
        end
        
        function [res,is_found] = put_chains(this,chains,res)
            for k = 1:numel(chains)
                name = '';
                for k1 = 1:numel(chains{k})
                    name = [name chains{k}{k1}.get_uname() ':'];
                    this.put('dr',name(1:end-1),CompressLib.compress(res{k}{k1}));
                end
            end
        end
        
        function img = get_img(this)
            img = this.imagedb.get_img(this.cid);
        end

        function [is_put,xor_key] = put(this,table,name,value,varargin)
            cfg.overwrite = false;
            cfg = cmp_argparse(cfg,varargin);

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
                res = KEY.xor(key_list{:});
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