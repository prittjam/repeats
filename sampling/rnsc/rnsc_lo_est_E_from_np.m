function res = rnsc_lo_est_E_from_np(u, sample_set, E0, cfg)

res = rnsc_get_best_model(u,{ E0 },cfg);
cfg.s = min([floor(sum(res.weights)/2) 14]);

if cfg.s > 5
    cfg.est_args = { E0 };
    res = rnsc_estimate(u, sample_set, cfg);
end