function [auto_id] = cvdb_ins_tc_cfg(conn, ...
                                     cfg, tc_cfg_hash)
connh = conn.Handle;

if nargin < 3
    [tc_cfg_hash tc_cfg_str] = cfg2hash(cfg,1);
end

sql_stmt = ['INSERT INTO tc_cfgs ' ...
            '(id) ' ...
            'VALUES (UNHEX(?))'];

stm = connh.prepareStatement(sql_stmt);
stm.setString(1, tc_cfg_hash);
stm.execute();