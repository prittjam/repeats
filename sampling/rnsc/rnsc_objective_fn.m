function [score weights] = rnsc_objective_fn(d2,u,s,cfg)
    weights = d2 < cfg.t;
    score = sum(weights);