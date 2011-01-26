function [gs_id] = cvdb_ins_gs_results(conn, title, exp_id, ...
                                       res, cfg, tags)
    connh = conn.Handle;

    if isconnection(conn)
        if ~isempty(cfg)
            [gs_cfg_exist, gs_cfg_hash] = cvdb_sel_gs_cfg_exist(conn, cfg);
            if (~gs_cfg_exist)
                gs_cfg_hash = cvdb_ins_gs_cfg(conn, cfg, gs_cfg_hash);
            end
        end

        cfg_hash = cfg2hash(cfg);
        stm = connh.prepareStatement(['INSERT INTO gs ' ...
                            '(title, exp_id, cfg_id, ' ...
                            'inlying_set, errors, score, ' ...
                            'samples_drawn, ' ...
                            'us_time_elapsed) ' ...
                            'VALUES(?,?,UNHEX(?),?,?,?,?,?)'], ...
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