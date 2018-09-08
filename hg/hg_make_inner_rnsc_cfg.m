%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function cfg = hg_make_inner_rnsc_cfg(cfg) 
cfg.model_fn = @hg_est_np_lsqnonlin;
cfg.min_trials = 10;
cfg.max_trials = 10;
cfg.max_data_retries = 1e2;
cfg.confidence = 0.999;
