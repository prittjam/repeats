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
        sql_query_1 = ['SELECT url, imgs.name, ext, height, width ' ...
                       'FROM stereo_sets JOIN img_pairs JOIN imgs ' ...
                       'WHERE stereo_sets.pair_id=img_pairs.id ' ...
                       'AND ' img_num  '=imgs.id ' ...
                       'AND stereo_sets.name=?'];
        
        stm = connh.prepareStatement(sql_query_1);
        stm.setString(1, set_name);
        rs = stm.executeQuery();

        img_num = 'img2_id';
        sql_query_2 = ['SELECT url, imgs.name, ext, height, width ' ...
                       'FROM stereo_sets JOIN img_pairs JOIN imgs ' ...
                       'WHERE stereo_sets.pair_id=img_pairs.id ' ...
                       'AND ' img_num  '=imgs.id ' ...
                       'AND stereo_sets.name=?'];
        
        stm = connh.prepareStatement(sql_query_2);
        stm.setString(1, set_name);
        rs2 = stm.executeQuery();
 
        stereo_set = {};
        row_num = 0;
        while (rs.next() && rs2.next())
            row_num = row_num+1

            stereo_set(row_num).img1.url = ...
                char(rs.getString(1));
            stereo_set(row_num).img1.height = ...
                rs.getInt(4);
            stereo_set(row_num).img1.width = ...
                rs.getInt(5);

            stereo_set(row_num).img2.url = ...
                char(rs2.getString(1));
            stereo_set(row_num).img2.height = ...
                rs2.getInt(4);
            stereo_set(row_num).img2.width = ...
                rs2.getInt(5);
        end
    end