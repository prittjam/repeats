%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [score weights] = rnsc_objective_fn(d2,u,s,cfg)
    weights = d2 < cfg.t;
    score = sum(weights);