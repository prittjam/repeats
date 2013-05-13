function [score weights] = rnsc_objective_fn(d2,u,s,sample,cfg)
    weights = d2 < cfg.tsq;
    score = sum(weights);