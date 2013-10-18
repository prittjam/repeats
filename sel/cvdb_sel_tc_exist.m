function [tc_exist] = cvdb_sel_tc_exist(conn, ...
                                        cfg, pair_hash, tc_cfg_hash)
    connh = conn.Handle;
    [tc_cfg] = cvdb_make_tc_cfg(cfg);

    if nargin < 4
        tc_cfg_hash = cfg2hash(tc_cfg,1);
    end

    sql_query = ['SELECT COUNT(*) ' ...
                 'FROM tc ' ...
                 'WHERE tc.id=UNHEX(?) ' ... 
                 'AND tc.pair_id=UNHEX(?)'];
    
    stm = connh.prepareStatement(sql_query);
    stm.setString(1, tc_cfg_hash);
    stm.setString(2, pair_hash);
    rs = stm.executeQuery();
    rs.next();
    tc_exist = rs.getInt(1);