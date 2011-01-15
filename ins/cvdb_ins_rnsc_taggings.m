function [] = cvdb_ins_rnsc_taggings(conn, ...
                                     tag_list, rnsc_key_list)
    connh = conn.Handle;
    
    for i = 1:length(tag_list)
        stm = connh.prepareStatement(['SELECT COUNT(*) FROM tags ' ...
                            'WHERE name=?']);
        stm.setString(1, tag_list{i});
        rs = stm.executeQuery();
        rs.next();
        count = rs.getInt(1);
        if (count == 0)
            stm = connh.prepareStatement(['INSERT INTO tags (name)' ...
                                'VALUES (?)']);
            stm.setString(1, tag_list{i});
            stm.execute();
        end
    end

    for i = 1:length(tag_list)
        stm = connh.prepareStatement(['SELECT id FROM tags ' ...
                            'WHERE name=?']);
        stm.setString(1, tag_list{i});
        rs2 = stm.executeQuery();
        if (rs2.next())
            tag_id = rs2.getInt(1); 
            for j = 1:length(rnsc_key_list)
                stm2 = connh.prepareStatement(['INSERT INTO rnsc_taggings ' ...
                                    '(rnsc_id, tag_id) ' ...
                                    'VALUES(?, ?)']);
                stm2.setInt(1, rnsc_key_list(j));
                stm2.setInt(2, tag_id);
                stm2.addBatch();
            end

        end
        stm2.executeBatch();
    end