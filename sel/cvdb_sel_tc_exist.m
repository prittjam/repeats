function [tc_exist] = cvdb_sel_tc_exist(conn, ...
                                        cfg, pair_hash)
    connh = conn.Handle;
    [tc_cfg, tc_cfg_hash] = cvdb_make_tc_cfg(cfg);

    sql_query = ['SELECT COUNT(*) ' ...
                 'FROM tc ' ...
                 'WHERE tc.cfg_id=UNHEX(?) ' ... 
                 'AND tc.pair_id=UNHEX(?)'];
    
    stm = connh.prepareStatement(sql_query);
    stm.setString(1, tc_cfg_hash);
    stm.setString(2, pair_hash);
    rs = stm.executeQuery();
    rs.next();
    tc_exist = rs.getInt(1);