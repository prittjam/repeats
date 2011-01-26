function [gs_cfg_exist, h] = cvdb_sel_gs_cfg_exist(conn, gs_cfg)
    connh = conn.Handle;

    h = cfg2hash(gs_cfg);
    
    sql_statement = ['SELECT COUNT(*) FROM gs_cfgs WHERE id=' ...
                     'UNHEX(?)'];
    stm = connh.prepareStatement(sql_statement);
    stm.setString(1, h);
    rs = stm.executeQuery();
    rs.next();
    gs_cfg_exist = rs.getInt(1);
