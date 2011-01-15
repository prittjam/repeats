function [] = cvdb_ins_tc(conn, ...
                          u, ...
                          us_time_elapsed, us_time_elapsed_scv, ...
                          img1, img2, ...
                          type)
    connh = conn.Handle;

    h = char(zeros(2,64));
    h(1,:) = cvdb_hash_img(img1);
    h(2,:) = cvdb_hash_img(img2);
    xorh = cvdb_img_hash_xor(h(1,:), h(2,:));

    stm = connh.prepareStatement(['INSERT INTO tc ' ...
                        '(tc, pair_id, count, count_scv, type, us_time_elapsed, us_time_elapsed_scv) ' ...
                        'VALUES(?,UNHEX(?),?,?,?,?,?)']);
    stm.setObject(1, u);
    stm.setString(2, xorh);
    stm.setInt(3, size(u,2));
    stm.setInt(4, size(u,2));
    stm.setString(5, type);
    stm.setInt(6,us_time_elapsed);
    stm.setInt(7,us_time_elapsed_scv);
    
    stm.execute();
    close(stm);