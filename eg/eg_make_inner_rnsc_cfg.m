function cfg = make_eg_inner_rnsc_cfg(cfg) 
cfg.model_fn = @eg_est_np_lsqnonlin;
cfg.min_trials = 20;
cfg.max_trials = 20;
cfg.max_data_retries = 1e2;
cfg.confidence = 0.999;