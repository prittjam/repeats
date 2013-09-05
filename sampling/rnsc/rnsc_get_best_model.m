function res = rnsc_get_best_model(u,s,sample,model_list,cfg)
res.score = inf;

if ~iscell(model_list)
    model_list = { model_list };
end

for i = 1:length(model_list)
    M = model_list{ i };
    C = feval(cfg.cost_fn,u,s,sample,M,cfg);
    [model_score weights] = feval(cfg.objective_fn,C,u,s,sample,cfg);
    if (cfg.compare(model_score,res.score))
        res.weights = weights;
        res.labels = weights > 0.5;
        res.score = model_score;
        res.model = M;
        res.C = C;
        %        res.t = cfg.t;
    end
end