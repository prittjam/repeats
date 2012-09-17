function res = rnsc_get_best_model(u,model_list,cfg)
res.score = -inf;

for i = 1:length(model_list)
    M = model_list{ i };
    dx2 = feval(cfg.error_fn,u,M);
    [model_score res.weights] = feval(cfg.objective_fn,dx2,cfg.objective_args{ : });
    if (model_score > res.score)
        res.score = model_score;
        res.model = M;
        res.errors = dx2;
    end
end