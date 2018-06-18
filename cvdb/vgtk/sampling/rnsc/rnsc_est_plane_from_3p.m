function res = rnsc_est_plane_from_3p(u,sample_set,threshold,confidence)
cfg.s = 3;
cfg.t = threshold;
cfg.confidence = confidence;
cfg.max_trials = 1e5;

% model functions
cfg.est_fn = @plane_est_n_from_3p;
cfg.error_fn = @(u,n) plane_reproj_err(u,n).^2;

% sampling degeneracy
cfg.sample_degen_fn = @plane_sample_degen;
cfg.sample_degen_args = { 1e-3, cfg.s };

cfg = rnsc_standardize_cfg(cfg);

%% local optimzation
cfg.lo = rnsc_lo_make_est_plane_from_np_cfg(cfg);
cfg.lo.fn = @rnsc_lo_est_plane_from_np;

res = rnsc_estimate(u,sample_set,cfg);
