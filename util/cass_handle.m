function handle=cass_handle()
%
% returns singleton object holding initialised CASS_STORAGE structure
%
   global CASS_STORAGE;
   % holds variables neccessary to access images and their attachments
   global CASS_CFG;

   if ~isstruct(CASS_STORAGE)
      if ~isfield(CASS_CFG, 'cass_read_consistency_level') || ~isfield(CASS_CFG, 'cass_read_consistency_level') % posibilities are {'ALL', 'ANY', 'ONE', 'QUORUM'}
         CASS_STORAGE.ca = imagedb.CassandraAccessor(CASS_CFG.imagedb_cluster); %should be 'cmpgrid_cassandra'
      else
         CASS_STORAGE.ca = imagedb.CassandraAccessor(CASS_CFG.imagedb_cluster); %should be 'cmpgrid_cassandra'
      end
      CASS_STORAGE.cf = 'image';
      CASS_STORAGE.retry_count = 5;
      if (isfield(CASS_CFG, 'storage'))
         if (isfield(CASS_CFG.storage, 'retry_count'))
            CASS_STORAGE.retry_count = CASS_CFG.storage.retry_count;
         end         
         if (isfield(CASS_CFG.storage, 'cf'))
            CASS_STORAGE.cf = CASS_CFG.storage.cf;
         end
      end      
   end;
   
   handle=CASS_STORAGE;
end
