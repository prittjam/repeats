function res = rnsc_est_E_from_5p(u,sample_set,threshold,confidence)
cfg.s = 5;
cfg.t = threshold;
cfg.confidence = confidence;
cfg.max_trials = 1e5;

% model functions
cfg.est_fn = @eg_est_E_from_5p_gb;
cfg.error_fn = @(u,F) sum(eg_sampson_err(u,F).^2);

% sampling degeneracy
cfg.sample_degen_fn = @eg_sample_degen;
cfg.sample_degen_args = { cfg.t, cfg.s };

cfg = rnsc_standardize_cfg(cfg);

% local optimzation
cfg.lo = rnsc_lo_make_est_E_from_np_cfg(cfg);
cfg.lo.fn = @rnsc_lo_est_E_from_np;

res0 = rnsc_estimate(u,sample_set,cfg);

gs_cfg = cfg.lo;
gs_cfg.epsilon = 1;

res = gs_estimate(u,res0.weights,res0,gs_cfg);