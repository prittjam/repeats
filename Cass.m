classdef Cass < handle
    properties
        cfg, 
        ckvs_table_cache
    end
    
    methods 
        function storage = create_handle(this,cassConf)
            keys = struct(...
                'cid',ColumnType.TEXT,...
                'key',ColumnType.TEXT);
            values = struct(...
                'data',ColumnType.MDATA);
            
            opts = rmfield(cassConf, {'keyspace','table'});
            opts = [fieldnames(opts)'; struct2cell(opts)'];
            storage = CassandraDataStore(cassConf.keyspace, cassConf.table, keys, values, opts{:});
        end
        
        function storage = get_handle(this,arg_cass_conf)
            if nargin < 1
                arg_cass_conf = struct();
            end
            
            def_cass_conf = struct(...
                'keyspace','engine', ...
                'table','data',...
                'nodes',char({'192.168.85.151'}),... %,'147.32.84.158','147.32.84.159'}),...
                'replicationFactor',2);
            %,...         'strategy','SimpleStrategy');


            if ~isfield(this.cfg, 'storage'), this.cfg.storage = struct(); end
            if ~isfield(this.cfg.storage, 'ncass_conf'), this.cfg.storage.ncass_conf = struct(); end
            % Override the default settings with global setting
            cass_conf = optmerge(def_cass_conf, this.cfg.storage.ncass_conf);
            % Override the global settings with default settings
            cass_conf = optmerge(cass_conf, arg_cass_conf);

            if isempty(this.ckvs_table_cache)
                this.ckvs_table_cache = struct();
            end

            tableName = cass_conf.table;
            if isfield(this.ckvs_table_cache,tableName)
                if isequal(this.ckvs_table_cache.(tableName).conf, cass_conf)
                    storage = this.ckvs_table_cache.(tableName).storage;
                    return;
                else
                    fprintf('Closing connection, it may take some time.\n');
                    this.ckvs_table_cache.(tableName).storage.close();
                end
            end
            storage = this.create_handle(cass_conf);
            this.ckvs_table_cache.(tableName).storage = storage;
            this.ckvs_table_cache.(tableName).conf = cass_conf;
        end

        
        function tablename = get_table_name(this,attribute,opt)
            if ~exist('opt','var'), opt = struct(); end;
            tablename = 'data';
            if isfield(opt,'cf')
                % in this way it is used in /matlab/knnvocab/0_detect/processjob.m
                tablename = opt.cf;
                
                opt = rmfield(opt,'cf');
                if ~isempty(fieldnames(opt))
                    warning('Additional options are not supported by cassandra CQL driver.');
                end
                return;
            end

            
            % In the rest of the scripts, the tablename is usually expressed as
            % 'tablename:somethingelse'
            
            rawKey = ':raw';
            rawPos = strfind(attribute,rawKey);
            if length(attribute) - rawPos + 1 == length(rawKey) % must be a suffix
                attribute = strrep(attribute,':raw',''); % Remove :raw tag from the string
            end
            
            if strcmp(attribute,'image')
                tablename = 'image';
                return;
            end
            
            colonPos = strfind(attribute,':');
            if colonPos > 0
                tablename = attribute(1:(colonPos-1));
            end
        end        


        function result = check(this,cid, attribute, opt)
            if ~exist('opt','var'), opt = struct(); end;
            if iscell(cid), cid = cid{1}; end
            
            % Remove :raw from the attribute
            rawPos = strfind(attribute,':raw');
            if rawPos
                attribute = attribute(1:(rawPos-1));
            end
            
            tablename = this.get_table_name(attribute,opt);
            storage = this.get_handle(struct('table',tablename));
            
            keys = storage.buildKeys(cid, attribute);
            
            result = storage.exist(keys);
        end
        
        function put(this, cid, data, attribute, opt)
            if ~exist('opt','var'), opt = struct(); end;

            if iscell(cid), cid = cid{1}; end

            runHooks = true;

            rawKey = ':raw';
            rawPos = strfind(attribute,rawKey);
            if length(attribute) - rawPos + 1 == length(rawKey) % must be a suffix
                runHooks = false;
                attribute = attribute(1:(rawPos-1));
                if ~isa(data,'uint8')
                    error('Raw data must be of type "uint8".');
                end
                if size(data,2) ~= 1
                    error('Raw data must be a column vector.');
                end
                data = typecast(data,'int8');
            end

            tablename = this.get_table_name(attribute,opt);
            storage = this.get_handle(struct('table',tablename));

            keys = storage.buildKeys(cid, attribute);
            values = storage.buildValues(data);

            storage.store(keys, values, runHooks);
        end
        
        function [result, errmessage] = get(this, cid, attribute, opt)
            errmessage = [];
            if ~exist('opt','var'), opt = struct(); end;		

            if iscell(cid), cid = cid{1}; end

            runHooks = true;

            rawPos = strfind(attribute,':raw');
            if rawPos
		runHooks = false;
		attribute = attribute(1:(rawPos-1));
            end

            tablename = this.get_table_name(attribute,opt);
            storage = this.get_handle(struct('table',tablename));

            keys = storage.buildKeys(cid, attribute);
            cass_res = storage.load(keys, runHooks);

            % In case the row does not exist, return empty array
            if isempty(cass_res)
		result = [];
		errmessage = 'missing';
		return;
            end

            result = cass_res.data;

            if rawPos
		arr = typecast(result.array, 'uint8');
		% Take only the data without the cassandra header
		result = arr((result.position+1):end);
            end
        end
    end
end