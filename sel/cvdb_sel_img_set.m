function img_set = cvdb_sel_img_set(conn, set_name)
connh = conn.Handle;

img_set = {};

stm = connh.prepareStatement(['SELECT COUNT(*) FROM img_sets ' ...
                    'WHERE name=?']);
stm.setString(1, set_name);
rs = stm.executeQuery();
rs.next();
count = rs.getInt(1);

if (count > 0)    
    sql_query = ['SELECT url,height,width ' ...
                 'FROM img_sets JOIN imgs ' ...
                 'WHERE img_sets.img_id=imgs.id ' ...
                 'AND img_sets.name=?'];

    stm = connh.prepareStatement(sql_query);
    stm.setString(1, set_name); 
    rs = stm.executeQuery();

    img_set = {};
    row_num = 0;
    while (rs.next())
        row_num = row_num+1;

        img_set(row_num).url = char(rs.getString(1));
        img_set(row_num).height = rs.getInt(2);
        img_set(row_num).width = rs.getInt(3);
    end
end