function [count, det_hash, pair_hash, desc_hash, ] = do_tc_exist(conn, ...
                                                      cfg, img1, img2)
    det_hash = cfg2hash(cfg.detectors);
    desc_hash = cfg2hash(cfg.descriptors);
    tc_hash = cfg2hash(cfg.tc);
    pair_hash = cvdb_hash_img_pair(img1, img2);

    sql_query = ['SELECT COUNT(*) ' ...
                 'FROM tc_cfgs JOIN descriptor_cfgs JOIN detector_cfgs ' ...
                 'WHERE detector_cfgs.id=UNHEX(?) AND ' ...
                 'descriptor_cfgs.id=UNHEX(?) AND tc_cfgs.id=UNHEX(?)  ' ...
                 'AND detector_cfgs.pair_id=UNHEX(?) AND descriptor_cfgs.pair_id=UNHEX(?) ' ...
                 'AND tc_cfgs.pair_id=UNHEX(?)'];

    stm = connh.prepareStatement(sql_query);

    stm.setString(1, det_hash);
    stm.setString(2, desc_hash);
    stm.setString(3, tc_hash);
    stm.setString(4, pair_hash);
    stm.setString(5, pair_hash);
    stm.setString(6, pair_hash);

    rs = stm.executeQuery();