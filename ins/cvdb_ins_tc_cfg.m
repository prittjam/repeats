function [auto_id] = cvdb_ins_tc_cfg(conn, ...
                                     cfg)

connh = conn.Handle;

[tc_cfg_hash tc_cfg_str] = cfg2hash(cfg);
[tc_cfg, tc_cfg_hash] = cvdb_make_tc_cfg(cfg);

sql_stmt = ['INSERT INTO tc_cfgs ' ...
            '(id) ' ...
            'VALUES (UNHEX(?))'];

stm = connh.prepareStatement(sql_stmt);
stm.setString(1, tc_cfg_hash);
stm.execute();