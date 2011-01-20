function [auto_id] = cvdb_ins_tc(conn, ...
                                 cfg, u, us_time_elapsed, ...
                                 img1, img2, ...
                                 tags)
    
    connh = conn.Handle;

    pair_hash = cvdb_hash_img_pair(img1, img2);

    [tc_cfg, tc_cfg_hash] = cvdb_make_tc_cfg(cfg);
    [tc_cfg_exist] = cvdb_sel_tc_cfg_exist(conn, tc_cfg);
    
    if (~tc_cfg_exist)
        cvdb_ins_tc_cfg(conn, tc_cfg);        
    end
    
    stm = connh.prepareStatement(['INSERT INTO tc ' ...
                        '(cfg_id, pair_id, data, count, us_time_elapsed) ' ...
                        'VALUES(UNHEX(?),UNHEX(?),?,?,?)'], ...
                                 java.sql.Statement.RETURN_GENERATED_KEYS);
    
    stm.setString(1, tc_cfg_hash);
    stm.setString(2, pair_hash);
    stm.setObject(3, u);
    stm.setInt(4, size(u,2));
    stm.setInt(5, us_time_elapsed);

    stm.execute();
    rs = stm.getGeneratedKeys();
    rs.next();
    auto_id = rs.getInt(1);
    
    close(stm);