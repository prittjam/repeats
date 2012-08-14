function cvdb_init(wbs_base_path)
global conn CASS_CFG

CASS_CFG.db_root = '/mnt/fry';
CASS_CFG.imagedb_cluster = 'cmpgrid_cassandra';

conn = cvdb_open('bayes.felk.cvut.cz', ...
                 'ransac', ...
                 'prittjam', ...
                 'J4m3SP');

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

conn.imagedb.storage.check = 'cass_imagecheck';
conn.imagedb.storage.get = 'cass_imageget';
conn.imagedb.storage.put = 'cass_imageput';
conn.imagedb.storage.remove = 'cass_imageremove';
conn.imagedb.storage.tostr = 'item2str';
conn.imagedb.storage.list = 'imagelist';

conn.imagedb.storage = translate_interfaces(conn.imagedb.storage);

conn.imagedb.storage.retry_count = 25;
conn.imagedb.storage.db_root = '/mnt/fry';
