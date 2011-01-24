function [auto_id] = cvdb_ins_rnsc_results(conn, title, res, cfg_hash, tag_list)
    connh = conn.Handle;
    
    stm = connh.prepareStatement(['INSERT INTO rnsc ' ...
                        '(title, cfg_id, ' ...
                        'inlying_set, errors, score, ' ...
                        'samples_drawn, sample_degen_count, ' ...
                        'us_time_elapsed) ' ...
                        'VALUES(?,UNHEX(?),?,?,?,?,?,?)'], ...
                                 java.sql.Statement.RETURN_GENERATED_KEYS);
    
    stm.setString(1, title);
    stm.setString(2, cfg_hash);
    
    if isfield(res, 'inlying_set')
        stm.setObject(3, res.inlying_set);
    else
        stm.setNull(3, java.sql.Types.BLOB);
    end
    
    if isfield(res, 'errors')
        stm.setObject(4, res.errors);
    else
        stm.setNull(4, java.sql.Types.BLOB);
    end 
    
    if isfield(res, 'score')
        stm.setInt(5, res.score);
    else
        stm.setNull(5, java.sql.Types.DOUBLE);
    end
    
    stm.setInt(6, res.samples_drawn);

    if isfield(res, 'sample_degen_count')
        stm.setInt(7, res.sample_degen_count);    
    else
        stm.setNull(7, java.sql.Types.INTEGER);
    end
    
    if isfield(res, 'us_time_elapsed')
        stm.setInt(8, res.us_time_elapsed);    
    else
        stm.setNull(8, java.sql.Types.INTEGER);
    end
    
    stm.execute();

    rs = stm.getGeneratedKeys()

    auto_id = 0;
    if rs.next()
        auto_id = rs.getInt(1);
        if (~isempty(tag_list))
            cvdb_ins_rnsc_taggings(conn, tag_list, auto_id);
        end
    end