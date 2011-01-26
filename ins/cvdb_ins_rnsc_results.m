function [auto_id] = cvdb_ins_rnsc_results(conn, title, exp_id, ...
                                           res, cfg, tag_list)
    connh = conn.Handle;
    
    if isconnection(conn)
        if ~isempty(cfg)
            [rnsc_cfg_exist, rnsc_cfg_hash] = cvdb_sel_rnsc_cfg_exist(conn, cfg);
            if (~rnsc_cfg_exist)
                rnsc_cfg_hash = cvdb_ins_rnsc_cfg(conn, cfg, rnsc_cfg_hash);
            end
        end

        cfg_hash = rnsc_cfg_hash;
        stm = connh.prepareStatement(['INSERT INTO rnsc ' ...
                            '(experiment_title, exp_id, cfg_id, ' ...
                            'inlying_set, errors, score, ' ...
                            'samples_drawn, sample_degen_count, ' ...
                            'us_time_elapsed) ' ...
                            'VALUES(?,?,UNHEX(?),?,?,?,?,?,?)'], ...
                                     java.sql.Statement.RETURN_GENERATED_KEYS);
        
        stm.setString(1, title);
        stm.setInt(2, exp_id);
        stm.setString(3, cfg_hash);
        
        if isfield(res, 'inlying_set')
            stm.setObject(4, res.inlying_set);
        else
            stm.setNull(4, java.sql.Types.BLOB);
        end
        
        if isfield(res, 'errors')
            stm.setObject(5, res.errors);
        else
            stm.setNull(5, java.sql.Types.BLOB);
        end 
        
        if isfield(res, 'score')
            stm.setInt(6, res.score);
        else
            stm.setNull(6, java.sql.Types.DOUBLE);
        end
        
        stm.setInt(7, res.samples_drawn);

        if isfield(res, 'sample_degen_count')
            stm.setInt(8, res.sample_degen_count);    
        else
            stm.setNull(8, java.sql.Types.INTEGER);
        end
        
        if isfield(res, 'us_time_elapsed')
            stm.setInt(9, res.us_time_elapsed);    
        else
            stm.setNull(9, java.sql.Types.INTEGER);
        end
        
        stm.execute();

        rs = stm.getGeneratedKeys();

        auto_id = 0;
        if rs.next()
            auto_id = rs.getInt(1);
            if (~isempty(tag_list))
                cvdb_ins_rnsc_taggings(conn, tag_list, auto_id);
            end
        end

    end