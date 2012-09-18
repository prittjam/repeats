function [score weights] = rnsc_objective_fn(d,varargin)
    t = varargin{1};
    weights = d < t^2;
    score = sum(weights);