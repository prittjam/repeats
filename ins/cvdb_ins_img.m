function h = cvdb_ins_img(conn, img, ...
                               absolute_path, rel_pth, img_name, ...
                               ext)
    connh = conn.Handle;    

    h = cvdb_hash_img(img);
    width  = size(img,2);
    height = size(img,1);

    stm =  connh.prepareStatement(['INSERT INTO imgs ' ...
                        'VALUES(UNHEX(?),?,?,?,?,?,?)']);
    stm.setString(1, h);
    stm.setString(2, absolute_path);
    stm.setString(3, rel_pth);
    stm.setString(4, img_name);
    stm.setString(5, ext);
    stm.setInt(6, width);
    stm.setInt(7, height);
    
    err = stm.execute();
    