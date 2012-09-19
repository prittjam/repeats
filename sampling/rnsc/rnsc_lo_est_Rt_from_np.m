function res = rnsc_lo_est_Rt_from_np(u,sample_set,M0,cfg)

res = rnsc_get_best_model(u,{ M0 },cfg);
cfg.s = min([floor(sum(res.weights)/2) 11]);

if cfg.s > 3
    cfg.est_args = { M0 };
    res = rnsc_estimate(u, sample_set, cfg);
end