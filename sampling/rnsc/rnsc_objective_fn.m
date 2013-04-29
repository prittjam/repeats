function [score weights] = rnsc_objective_fn(d2,u,s,sample,tsq)
    weights = d2 < tsq^2;
    score = sum(weights);