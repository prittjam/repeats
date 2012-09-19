function res = rnsc_get_best_model(u,model_list,cfg)
res.score = -inf;

if ~iscell(model_list)
    model_list = { model_list };
end

for i = 1:length(model_list)
    M = model_list{ i };
    dx2 = feval(cfg.error_fn,u,M);
    [model_score weights] = feval(cfg.objective_fn,dx2,cfg.objective_args{ : });
    if (model_score > res.score)
        res.weights = weights;
        res.score = model_score;
        res.model = M;
        res.errors = dx2;
        res.t = cfg.objective_args{ : };
    end
end