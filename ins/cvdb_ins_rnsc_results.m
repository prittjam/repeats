function [auto_id] = cvdb_ins_rnsc_results(conn, title, exp_id, tc_id, cfg, ...
                                           sample_set, tag_list)
    connh = conn.Handle;
    
    if ~isempty(cfg)
        rnsc_cfg_hash = cvdb_ins_rnsc_cfg(conn, cfg);
    end

    cfg_hash = rnsc_cfg_hash;
    stm = connh.prepareStatement(['INSERT INTO rnsc ' ...
                        '(experiment_title, exp_id, cfg_id, tc_id, sample_set) ' ...
                        'VALUES(?,?,UNHEX(?),UNHEX(?),?)'], ...
                                 java.sql.Statement.RETURN_GENERATED_KEYS);
    
    stm.setString(1, title);
    stm.setInt(2, exp_id);
    stm.setString(3, cfg_hash); 
    stm.setString(4, tc_id); 
    stm.setBytes(3, typecast(sample_set(:), 'uint8'));
    stm.execute();

    rs = stm.getGeneratedKeys();

    auto_id = 0;
    if rs.next()
        auto_id = rs.getInt(1);
        if (~isempty(tag_list))
            cvdb_ins_rnsc_taggings(conn, tag_list, auto_id);
        end
    end