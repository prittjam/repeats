function [t] = cvdb_ins_tc(conn, ...
                           u, ...
                           us_time_elapsed, ...
                           img1, img2, ...
                           type)
    connh = conn.Handle;

    cfg_tmp.detectors = cfg.detectors;
    cfg_tmp.descriptors = cfg.descriptors;
    cfg_tmp.tc = cfg.tc;

    cfg_hash = cfg2hash(cfg_tmp);
    pair_hash = cvdb_hash_img_pair(img1, img2);


    stm = connh.prepareStatement(['INSERT INTO tc ' ...
                        '(id, tc, pair_id, count, type, us_time_elapsed) ' ...
                        'VALUES(?,UNHEX(?),?,?,?,?,?)']);
    stm.setString(1, cfg_hash);

    stm.setObject(1, u);
    stm.setString(2, xorh);
    stm.setInt(3, size(u,2));
    stm.setInt(4, size(u,2));
    stm.setString(5, type);
    stm.setInt(6,us_time_elapsed);
    stm.setInt(7,us_time_elapsed_scv);
    
    stm.execute();
    close(stm);