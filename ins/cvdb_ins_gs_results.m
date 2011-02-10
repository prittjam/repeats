function [auto_id] = cvdb_ins_gs_results(conn, title, exp_id, ...
                                         res, cfg, tag_list)
    connh = conn.Handle;

    if ~isempty(cfg)
        [gs_cfg_exist, gs_cfg_hash] = cvdb_sel_gs_cfg_exist(conn, cfg);
        if (~gs_cfg_exist)
            gs_cfg_hash = cvdb_ins_gs_cfg(conn, cfg, gs_cfg_hash);
        end
    end 
    cfg_hash = cfg2hash(cfg);
    stm = connh.prepareStatement(['INSERT INTO gs ' ...
                        '(title, exp_id, cfg_id, ' ...
                        'weights, errors, score, ' ...
                        'iterations, ' ...
                        'us_time_elapsed) ' ...
                        'VALUES(?,?,UNHEX(?),?,?,?,?,?)'], ...
                                 java.sql.Statement.RETURN_GENERATED_KEYS);
    
    stm.setString(1, title);
    stm.setInt(2, exp_id);
    stm.setString(3, cfg_hash);
    
    if isfield(res, 'weights')
        stm.setBytes(4, typecast(double(res.weights(:)), 'uint8'));
    else
        stm.setNull(4, java.sql.Types.BLOB);
    end
    
    if isfield(res, 'errors')
        stm.setBytes(5, typecast(res.errors(:), 'uint8'));
    else
        stm.setNull(5, java.sql.Types.BLOB);
    end 
    
    if isfield(res, 'score')
        stm.setDouble(6, res.score);
    else
        stm.setNull(6, java.sql.Types.DOUBLE);
    end
    
    stm.setInt(7, res.iterations);

    if isfield(res, 'us_time_elapsed')
        stm.setInt(8, res.us_time_elapsed);    
    else
        stm.setNull(8, java.sql.Types.INTEGER);
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
