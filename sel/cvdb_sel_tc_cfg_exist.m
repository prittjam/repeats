function [tc_cfg_exist] = cvdb_sel_tc_cfg_exist(conn, cfg)
    connh = conn.Handle;
    [tc_cfg, tc_cfg_hash] = cvdb_make_tc_cfg(cfg);

    sql_query = ['SELECT COUNT(*) ' ...
                 'FROM tc_cfgs ' ...
                 'WHERE id=UNHEX(?)'];
    stm = connh.prepareStatement(sql_query);
    stm.setString(1, tc_cfg_hash);
    rs = stm.executeQuery();
    rs.next();
    tc_cfg_exist = rs.getInt(1);