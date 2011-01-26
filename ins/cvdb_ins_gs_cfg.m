function cfg_hash = cvdb_ins_gs_cfg(conn, cfg, cfg_hash)
    connh = conn.Handle;

    stm = connh.prepareStatement(['INSERT INTO gs_cfgs (' ...
                        'id, threshold, epsilon, ' ...
                        'min_trials, max_trials, ' ...
                        'model_fn, error_fn, score_fn, ' ...
                        'VALUES(UNHEX(?),?,?,?,?,?,?,?))']);
    
    stm.setString(1, cfg_hash);
    stm.setDouble(2, threshold_from_sigma(cfg.sigma));
    stm.setDouble(3, cfg.epsilon);
    stm.setInt(4, cfg.min_trials);
    stm.setInt(5, cfg.max_trials);
    stm.setString(6, cfg.model_fn);
    stm.setString(7, cfg.error_fn);    
    stm.setString(8, cfg.score_fn);    
    
    stm.execute();

    close(stm);