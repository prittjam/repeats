function [auto_id] = cvdb_ins_rnsc_results(conn, title, exp_id, tc_id, ...
                                           res, cfg, tag_list)
    connh = conn.Handle;
    
    if ~isempty(cfg)
        rnsc_cfg_hash = cvdb_ins_rnsc_cfg(conn, cfg);
    end

    cfg_hash = rnsc_cfg_hash;
    stm = connh.prepareStatement(['INSERT INTO rnsc ' ...
                        '(experiment_title, exp_id, cfg_id, tc_id, ' ...
                        'weights, errors, score, ' ...
                        'samples_drawn, sample_degen_count, ' ...
                        'us_time_elapsed) ' ...
                        'VALUES(?,?,UNHEX(?),?,?,?,?,?,?,?)'], ...
                                 java.sql.Statement.RETURN_GENERATED_KEYS);
    
    stm.setString(1, title);
    stm.setInt(2, exp_id);
    stm.setString(3, cfg_hash);
    stm.setBytes(4, typecast(double(res.weights(:)), 'uint8'));
    stm.setBytes(5, typecast(res.errors(:), 'uint8'));
    stm.setDouble(6, res.score);
    stm.setInt(7, res.samples_drawn);
    stm.setInt(8, res.sample_degen_count);    
    stm.setInt(9, res.us_time_elapsed);    
    
    stm.execute();

    rs = stm.getGeneratedKeys();

    auto_id = 0;
    if rs.next()
        auto_id = rs.getInt(1);
        if (~isempty(tag_list))
            cvdb_ins_rnsc_taggings(conn, tag_list, auto_id);
        end
    end