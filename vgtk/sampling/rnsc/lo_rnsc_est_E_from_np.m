%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function res = lo_rnsc_est_E_from_np(u, sample_set, cfg, varargin)
F0 = varargin{ 1 };

res = feval(cfg.select_model_fn, u, { F0 }, cfg);
cfg.s = min([floor(sum(res.weights)/2) 14]);

if cfg.s > 8
    cfg.model_args = { F0 };
    res = rnsc_estimate(u, sample_set, cfg);
end

function cfg = make_eg_inner_rnsc_cfg(cfg) 
cfg.model_fn = @eg_est_np_lsqnonlin;
cfg.min_trials = 20;
cfg.max_trials = 20;
cfg.max_data_retries = 1e2;
cfg.confidence = 0.999;