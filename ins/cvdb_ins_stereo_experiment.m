function [auto_id] = cvdb_ins_stereo_experiment(conn, set_id, ...
                                                title, pair_id, cfg)	
    connh = conn.Handle;
    cfg_id = cfg2hash(cfg);
    stm = connh.prepareStatement(['INSERT INTO stereo_experiments ' ...
                        '(set_id, title, pair_id, cfg_id) ' ...
                        'VALUES(?,?,UNHEX(?),UNHEX(?))'], ...
                                 java.sql.Statement.RETURN_GENERATED_KEYS);

    stm.setString(1, set_id);
    stm.setString(2, title);
    stm.setString(3, pair_id);
    stm.setString(4, cfg_id);

    stm.execute();
    rs = stm.getGeneratedKeys();

    auto_id = 0;
    if rs.next()
        auto_id = rs.getInt(1);
%        if (~isempty(tag_list))
%            cvdb_ins_rnsc_taggings(conn, tag_list, auto_id);
%        end
    end