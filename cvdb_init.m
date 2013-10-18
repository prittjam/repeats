function conn = cvdb_init(wbs_base_path)
x = dbstatus; 
cvdb_addpaths(wbs_base_path);
dbstop(x);

global CASS_CFG conn;

fid = fopen('cvdb.cfg');
text = textscan(fid,'%s','Delimiter','\n');
credentials = text{:};

conn = cvdb_open(credentials{1}, ...
                 credentials{2}, ...
                 credentials{3}, ...
                 credentials{4});

% === mandatory part (in the most cases stays unchanged) === %
conn.imagedb.verbose                = 0;
conn.imagedb.master_isfinished      = false;
conn.imagedb.min_chunk_size         = 10;
conn.imagedb.mypath                 = fileparts(mfilename('fullpath'));
% === end of mandatory part === %

% database for storing configurations
conn.imagedb.confdb.schema = 'config';
conn.imagedb.confdb.user   = 'perdom1';
conn.imagedb.confdb.pass   = '';

% configure data access
conn.imagedb.imagedb_cluster = 'cmpgrid_cassandra';

conn.imagedb.storage.check = 'cass_cql_imagecheck';
conn.imagedb.storage.get = 'cass_cql_imageget';
conn.imagedb.storage.put = 'cass_cql_imageput';
conn.imagedb.storage.remove = 'cass_cql_imageremove';
conn.imagedb.storage.tostr = 'item2str';
conn.imagedb.storage.list = 'imagelist';

CFG.storage.ncass_conf = struct('keyspace','james');

conn.imagedb.storage = translate_interfaces(conn.imagedb.storage);

conn.imagedb.storage.retry_count = 25;
conn.imagedb.storage.db_root = '/mnt/fry';
