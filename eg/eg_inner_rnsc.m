function res = eg_inner_rnsc(u, sample_set, cfg, varargin)
F0 = varargin{ 1 };

res = feval(cfg.select_model_fn, u, { F0 }, cfg);
cfg.s = min([floor(sum(res.weights)/2) 14]);

if cfg.s > 8
    cfg.model_args = { F0 };
    res = rnsc_estimate(u, sample_set, cfg);
end