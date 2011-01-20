function [tc] = cvdb_sel_tc(conn, cfg, img1, img2)
    connh = conn.Handle;

    pair_hash = cvdb_hash_img_pair(img1, img2);
    tc_cfg_hash = cfg2hash(cfg);

    sql_query = ['SELECT data ' ...
                 'FROM tc ' ...
                 'WHERE cfg_id=UNHEX(?) AND pair_id=UNHEX(?) ' ...
                ];
    
    stm = connh.prepareStatement(sql_query);
    stm.setString(1, tc_cfg_hash);
    stm.setString(2, pair_hash);
    
    rs = stm.executeQuery();

    tc = [];
    while (rs.next())
        row_num = row_num+1
        tc = rs.getObject(1);
    end