function [score weights] = rnsc_objective_fn(d,t)
    weights = d < t^2;
    score = sum(weights);