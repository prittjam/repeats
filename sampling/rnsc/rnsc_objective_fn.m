function [score weights] = rnsc_objective_fn(d,u,s,sample,t)
    weights = d < t^2;
    score = sum(weights);