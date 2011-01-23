function [height, width] = cvdb_sel_img_size(conn, abs_path)
    connh = conn.Handle;
    
    stm = connh.prepareStatement(['SELECT COUNT(*) FROM img ' ...
                        'WHERE absolute_path=?']);
    stm.setString(1, abs_path);
    rs = stm.executeQuery();
    rs.next();
    count = rs.getInt(1);

    if (count > 0)    
        sql_query = ['SELECT height, width FROM ' ...
                     'imgs ' ...
                     'WHERE absolute_path=?'];
        stm = connh.prepareStatement(sql_query);
        stm.setString(1, abs_path); 
        rs = stm.executeQuery();
        while (rs.next())
            height = rs.getInt(1);
            width = rs.getInt(2);
        end
    end
