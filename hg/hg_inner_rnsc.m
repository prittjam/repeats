function res = hg_inner_rnsc(u,sample_set,model,cfg)
res = feval(cfg.select_model_fn,u,{ model },cfg);
cfg.s = min([floor(sum(res.weights)/2) 12]);

if cfg.s > 7
    cfg.model_args = model;
    res = rnsc_estimate(u, sample_set, cfg);
end