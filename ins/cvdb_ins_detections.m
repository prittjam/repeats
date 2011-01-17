function [] = cvdb_ins_detections(conn, ...
                                  cfg, img1, img2, ...
                                  detections)
    connh = conn.Handle;

    h1 = cfg2hash(cfg);
    h2 = cvdb_hash_img_pair(img1, img2);

    xorh = cvdb_img_hash_xor(h(1,:), h(2,:));

    stm = connh.prepareStatement(['INSERT INTO detections ' ...
                        '(id, pair_id) ' ...
                        'VALUES(UNHEX(?),UNHEX(?))']);
    stm.setString(1, h1);
    stm.setString(2, h2);
    
    stm.execute();
    close(stm);