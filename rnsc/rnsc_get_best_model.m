function res = rnsc_get_best_model(u, model_list, cfg)
res.score = -inf;
t = cfg.t;

for i = 1:length(model_list)
    M = model_list{ i };
    dx2 = feval(cfg.error_fn,u,M);
    [model_score inl] = feval(cfg.score_fn,dx2,t);
    if (model_score > res.score)
        res.weights = inl;
        res.score = model_score;
        res.model = M;
        res.errors = dx2;
    end
end