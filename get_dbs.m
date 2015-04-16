function [sqldb,imagedb] = get_dbs(varargin)
cfg.sqldb_cfg = getenv('CVDB_SQLDB_CFG');
cfg.cass_cfg = getenv('CVDB_CASS_CFG');

[cfg,leftover] =  helpers.vl_argparse(cfg,varargin{:});

sqldb = SqlDb;
sqldb.open('cfg_file',cfg.sqldb_cfg);
imagedb = ImageDb('cfg_file',cfg.cass_cfg);