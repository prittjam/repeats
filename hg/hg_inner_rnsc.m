function res = hg_inner_rnsc(u,s,model,cfg)
res = rnsc_get_best_model(u,s,[],model,cfg);

%m = min([floor(sum(res.weights)/2) 12]);

if sum(res.weights) > cfg.k+1
    cfg.model_args = model;
    res = rnsc_estimate(u,s,cfg);
end