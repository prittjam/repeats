function cvdb_ins_tc(conn, ...
                     cfg, u, type, us_time_elapsed, ...
                     pair_hash, tc_cfg_hash, ...
                     tags)
    
    connh = conn.Handle;
    
    tc = cvdb_sel_tc(conn, ...
                     tc_cfg_hash, pair_hash);
    
    if isempty(tc)
        stm = connh.prepareStatement(['INSERT INTO tc ' ...
                            '(cfg_id, pair_id, data, count, type, us_time_elapsed) ' ...
                            'VALUES(UNHEX(?),UNHEX(?),?,?,?,?)']);
        
        stm.setString(1, tc_cfg_hash);
        stm.setString(2, pair_hash);
        stm.setObject(3, typecast(u(:), 'uint8'));
        stm.setInt(4, size(u,2));
        stm.setString(5, type);
        stm.setInt(6, us_time_elapsed);

        stm.execute();
        
        close(stm);
    end