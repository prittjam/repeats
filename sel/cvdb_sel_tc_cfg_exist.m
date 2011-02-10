function [tc_cfg] = cvdb_sel_tc_cfg_exist(conn, cfg, tc_cfg_hash)
    connh = conn.Handle;

    tc_cfg = {};
    sql_query = ['SELECT data ' ...
                 'FROM tc_cfgs ' ...
                 'WHERE id=UNHEX(?)'];
    stm = connh.prepareStatement(sql_query);
    stm.setString(1, tc_cfg_hash);
    rs = stm.executeQuery();
    if rs.next()
        tc_cfg = rs.getObject(1);
    end
