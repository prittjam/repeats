classdef Cass < handle
    properties(Access=private)
        ckvs_table_cache = struct();
        
%        lascar_ip_addr = {'192.168.85.151', ...
%                          '192.168.85.152', ...
%                          '192.168.85.153', ...
%                          '192.168.85.154', ...
%                          '192.168.85.155', ...
%                          '192.168.85.156', ...
%                          '192.168.85.157', ...
%                          '192.168.85.158', ...
%                          '192.168.85.159', ...
%                          '192.168.85.160', ...
%                          '192.168.85.161'},
%        

        lascar_ip_addr = {'192.168.85.151'};

        cass_cfg = struct(...
            'keyspace','engine', ...
            'table','data',...
            'nodes',[],...
            'replicationFactor',2);
        %,...         'strategy','SimpleStrategy');
    end
    
    methods 
        function this = Cass(varargin)
            this.cass_cfg.nodes = char(this.lascar_ip_addr);
            
            [this.cass_cfg,leftover] = cmp_argparse(this.cass_cfg, ...
                                                  varargin{:});
            if ~isempty(leftover)
                cfg.cfg_file = [];
                cfg = cmp_argparse(cfg,leftover);
                if ~isempty(cfg.cfg_file)
                    if exist(cfg.cfg_file,'file')
                        fid = fopen(cfg.cfg_file);
                        text = textscan(fid,'%s','Delimiter','\n');
                        credentials = text{:};
                        this.cass_cfg.keyspace = credentials{1};
                        this.cass_cfg.table = credentials{2};
                        this.cass_cfg.nodes = char(strsplit(credentials{3},','));
                        this.cass_cfg.replicationFactor = str2num(credentials{4});              
                    else
                        error('Config file does not exist');
                    end
                end
            end
        end

        function storage = create_handle(this,cass_cfg)
            keys = struct('cid',ColumnType.TEXT,...
                          'key',ColumnType.TEXT);
            values = struct('data',ColumnType.MDATA);
            
            opts = rmfield(cass_cfg, {'keyspace','table'});
            opts = [fieldnames(opts)'; struct2cell(opts)'];

            storage = CassandraDataStore(cass_cfg.keyspace, ...
                                         cass_cfg.table, ...
                                         keys, values, opts{:});
        end
        
        function storage = get_handle(this,varargin)
            cass_cfg = cmp_argparse(this.cass_cfg, varargin{:});

            tableName = cass_cfg.table;
            if isfield(this.ckvs_table_cache,tableName)
                if isequal(this.ckvs_table_cache.(tableName).cfg, cass_cfg)
                    storage = this.ckvs_table_cache.(tableName).storage;
                    return;
                else
                    fprintf('Closing connection, it may take some time.\n');
                    this.ckvs_table_cache.(tableName).storage.close();
                end
            end
            storage = this.create_handle(cass_cfg);

            this.ckvs_table_cache.(tableName).storage = storage;
            this.ckvs_table_cache.(tableName).cfg = cass_cfg;
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
            storage = this.get_handle('table',tablename);
            
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
            storage = this.get_handle('table',tablename);

            keys = storage.buildKeys(cid, attribute);
            values = storage.buildValues(data);
            warning('off','MATLAB:structOnObject');
            storage.store(keys, values, runHooks);
            warning('on','MATLAB:structOnObject');
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
            storage = this.get_handle('table',tablename);

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
