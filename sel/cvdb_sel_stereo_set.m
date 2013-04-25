function [stereo_set] = cvdb_sel_stereo_set(conn, set_name)
    connh = conn.Handle;

    stereo_set = {};
    stm = connh.prepareStatement(['SELECT COUNT(*) FROM stereo_sets ' ...
                        'WHERE name=?']);
    stm.setString(1, set_name);
    rs = stm.executeQuery();
    rs.next();
    count = rs.getInt(1);

    if (count > 0)    
        img_num = 'img1_id';

        sql_query_1 = ['SELECT im1.url, im1.height, im1.width, ' ...
                       'im2.url, im2.height, im2.width ' ...
                       'FROM stereo_sets AS ss ' ...
                       'INNER JOIN imgs AS im1 ON img1_id = im1.id ' ...
                       'INNER JOIN imgs AS im2 ON img2_id = im2.id ' ...
                       'WHERE ss.name = ?'];

        stm = connh.prepareStatement(sql_query_1);
        stm.setString(1, set_name);
        rs = stm.executeQuery();

        stereo_set = {};
        row_num = 0;
        while (rs.next())
            row_num = row_num+1;

            stereo_set(row_num).img1.url = ...
                char(rs.getString(1));
            stereo_set(row_num).img1.height = ...
                rs.getInt(2);
            stereo_set(row_num).img1.width = ...
                rs.getInt(3);

            stereo_set(row_num).img2.url = ...
                char(rs.getString(4));
            stereo_set(row_num).img2.height = ...
                rs.getInt(5);
            stereo_set(row_num).img2.width = ...
                rs.getInt(6);
        end
    end