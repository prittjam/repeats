%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function cfg = rnsc_lo_make_est_E_from_np_cfg(cfg) 
cfg.est_fn = @eg_est_E_from_np_lsqnonlin;
cfg.min_trials = 20;
cfg.max_trials = 20;
cfg.max_data_retries = 1e2;
cfg.confidence = 0.999;
cfg = rnsc_standardize_cfg(cfg);