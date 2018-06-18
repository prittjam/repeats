function [] = init_dbs(varargin)
cfg.sqldb_cfg = getenv('CVDB_SQLDB_CFG');
cfg.cass_cfg = getenv('CVDB_CASS_CFG');

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

sqldb = SQL.SqlDb.getObj(true,'cfg_file',cfg.sqldb_cfg);
cassdb = CASS.CassDb.getObj(true,'cfg_file',cfg.cass_cfg);
