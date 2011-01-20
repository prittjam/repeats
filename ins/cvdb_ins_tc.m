function [t] = cvdb_ins_tc(conn, ...
                           cfg,
                           u, ...
                           us_time_elapsed, ...
                           img1, img2, ...
                           type)
    connh = conn.Handle;


    pair_hash = cvdb_hash_img_pair(img1, img2);
    [tc_cfg, tc_cfg_hash] = cvdb_make_tc_cfg(conn, cfg)

    stm = connh.prepareStatement(['INSERT INTO tc ' ...
                        '(tc_cfg_hash, pair_hash, u, count, us_time_elapsed) ' ...
                        'VALUES(UNHEX(?),UNHEX(?),?,?,?)']);
    stm.setString(1, cfg_hash);
    stm.setString(2, pair_hash);
    stm.setObject(3, u);
    stm.setObject(4, size(u,2));
    stm.setInt(5, us_time_elapsed);
    
    stm.execute();
    close(stm);