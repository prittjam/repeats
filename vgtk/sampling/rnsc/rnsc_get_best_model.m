%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function res = rnsc_get_best_model(u,s,model_list,cfg)
if cfg.compare(0,inf)
    res.score = inf;
else
    res.score = -inf;
end

if ~iscell(model_list)
    model_list = { model_list };
end

for i = 1:length(model_list)
    M = model_list{ i };
    C = feval(cfg.cost_fn,u,s,M,cfg);
    [model_score weights] = feval(cfg.objective_fn,C,u,s,cfg);
    if (cfg.compare(model_score,res.score))
        res.weights = weights;
        res.labels = weights > 0.5;
        res.score = model_score;
        res.model = M;
        res.C = C;
        res.s = s;
        %        res.t = cfg.t;
    end
end