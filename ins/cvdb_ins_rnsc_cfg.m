function rnsc_cfg_hash = cvdb_ins_rnsc_cfg(conn, cfg, h)
    connh = conn.Handle;

    if nargin < 3
        [rnsc_cfg_exist, rnsc_cfg_hash] = cvdb_sel_rnsc_cfg_exist(conn, cfg);
    else
        [rnsc_cfg_exist, rnsc_cfg_hash] = cvdb_sel_rnsc_cfg_exist(conn, ...
                                                          cfg, h);
    end

    if (~rnsc_cfg_exist)
        
        stm = connh.prepareStatement(['INSERT INTO rnsc_cfgs (' ...
                            'id, sample_size, threshold, confidence, ' ...
                            'min_trials, max_trials, max_data_retries, ' ...
                            'model_fn, error_fn, score_fn, ' ...
                            'sample_degen_fn, model_degen_fn, ' ...
                            'lo_fn, always_model_degen)' ...
                            'VALUES(UNHEX(?),?,?,?,?,?,?,?,?,?,?,?,?,?)']);
        
        stm.setString(1, rnsc_cfg_hash);
        stm.setInt(2, cfg.s);
        stm.setDouble(3, threshold_from_sigma(cfg.sigma));
        stm.setDouble(4, cfg.confidence);
        stm.setInt(5, cfg.min_trials);
        stm.setInt(6, cfg.max_trials);
        stm.setInt(7, cfg.max_data_retries);    
        stm.setString(8, cfg.model_fn);
        stm.setString(9, cfg.error_fn);    
        stm.setString(10, cfg.score_fn);    
        stm.setString(11, cfg.sample_degen_fn);    
        stm.setString(12, cfg.model_degen_fn);    
        stm.setString(13, cfg.lo_fn);    
        stm.setBoolean(14, cfg.always_model_degen);  
        
        stm.execute();
        close(stm);
    end