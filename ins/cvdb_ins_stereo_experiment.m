function [auto_id] = cvdb_ins_stereo_experiment(conn, img1_id, img2_id, ...
                                                cfg_id, title)	
    connh = conn.Handle;
    stm = connh.prepareStatement(['INSERT INTO stereo_experiments ' ...
                        '(title,img1_id,img2_id,cfg_id) ' ...
                        'VALUES(?,UNHEX(?),UNHEX(?),UNHEX(?))'], ...
                                 java.sql.Statement.RETURN_GENERATED_KEYS);
    stm.setString(1,title);
    stm.setString(2,img1_id);
    stm.setString(3,img2_id);
    stm.setString(4,cfg_id);

    stm.execute();
    rs = stm.getGeneratedKeys();

    auto_id = 0;
    if rs.next()
        auto_id = rs.getInt(1);
%        if (~isempty(tag_list))
%            cvdb_ins_rnsc_taggings(conn, tag_list, auto_id);
%        end
    end