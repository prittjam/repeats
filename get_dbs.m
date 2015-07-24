function [sqldb,cassdb] = get_dbs(varargin)
cfg.sqldb_cfg = getenv('CVDB_SQLDB_CFG');
cfg.cass_cfg = getenv('CVDB_CASS_CFG');

[cfg,leftover] =  helpers.vl_argparse(cfg,varargin{:});

sqldb = SQL.SqlDb;
sqldb.open('cfg_file',cfg.sqldb_cfg);
cassdb = CASS.CassDb('cfg_file',cfg.cass_cfg);