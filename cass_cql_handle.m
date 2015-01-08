function storage = cass_cql_handle(arg_cass_conf)
   if nargin < 1
     arg_cass_conf = struct();
   end

   def_cass_conf = struct(...
         'keyspace','engine', ...
         'table','data',...
         'nodes',char({'localhost'}),... %,'147.32.84.158','147.32.84.159'}),...
         'replicationFactor',2);
				 %,...         'strategy','SimpleStrategy');

   global CFG CKVS_TABLE_CACHE;
   if ~isfield(CFG, 'storage'), CFG.storage = struct(); end
   if ~isfield(CFG.storage, 'ncass_conf'), CFG.storage.ncass_conf = struct(); end
   % Override the default settings with global setting
   cass_conf = optmerge(def_cass_conf, CFG.storage.ncass_conf);
   % Override the global settings with default settings
   cass_conf = optmerge(cass_conf, arg_cass_conf);

   if isempty(CKVS_TABLE_CACHE)
     CKVS_TABLE_CACHE = struct();
   end

   tableName = cass_conf.table;
   if isfield(CKVS_TABLE_CACHE,tableName)
     if isequal(CKVS_TABLE_CACHE.(tableName).conf, cass_conf)
       storage = CKVS_TABLE_CACHE.(tableName).storage;
       return;
     else
       fprintf('Closing connection, it may take some time.\n');
       CKVS_TABLE_CACHE.(tableName).storage.close();
     end
   end
   storage = create_handle(cass_conf);
   CKVS_TABLE_CACHE.(tableName).storage = storage;
   CKVS_TABLE_CACHE.(tableName).conf = cass_conf;
end

function storage = create_handle(cassConf)

   keys = struct(...
     'cid',ColumnType.TEXT,...
     'key',ColumnType.TEXT);
   values = struct(...
     'data',ColumnType.MDATA);

   opts = rmfield(cassConf, {'keyspace','table'});
   opts = [fieldnames(opts)'; struct2cell(opts)'];
   storage = CassandraDataStore(cassConf.keyspace, cassConf.table, keys, values, opts{:});

end
