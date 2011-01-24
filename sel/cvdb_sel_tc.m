function [tc] = cvdb_sel_tc(conn, cfg, pair_hash)
    connh = conn.Handle;

    tc_cfg_hash = cfg2hash(cfg);

    sql_query = ['SELECT data,count,type ' ...
                 'FROM tc ' ...
                 'WHERE cfg_id=UNHEX(?) AND pair_id=UNHEX(?) ' ...
                ];
    
    stm = connh.prepareStatement(sql_query);
    stm.setString(1, tc_cfg_hash);
    stm.setString(2, pair_hash);
    
    rs = stm.executeQuery();

    tc = [];
    row_num = 0;
    while (rs.next())
        row_num = row_num+1
        count = rs.getInt(2);
        tc_type = char(rs.getString(3));
        switch tc_type
            case 'LAF'
              tc = reshape(typecast(rs.getObject(1), 'double'), 18, ...
                           count);
        end
    end