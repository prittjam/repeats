%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function res = rnsc_est_Rt_from_3p(u,threshold,confidence)
sample_set = true(1,size(u,2));

cfg.s = 3;
cfg.t = threshold;
cfg.confidence = confidence;
cfg.max_trials = 1e5;

% model functions
cfg.est_fn = @ao_est_Rt_from_3p;
cfg.error_fn = @(u,M) sum(ao_reproj_err(u,M).^2);

% sampling degeneracy
cfg.sample_degen_fn = @ao_est_Rt_sample_degen;
cfg.sample_degen_args = { cfg.t };

% local optimzation
cfg.lo = rnsc_lo_make_est_Rt_from_np_cfg(cfg);
cfg.lo.fn = @rnsc_lo_est_Rt_from_np;

cfg = rnsc_standardize_cfg(cfg);

res0 = rnsc_estimate(u,sample_set,cfg);

gs_cfg = cfg.lo;
gs_cfg.epsilon = 1;

res = gs_estimate(u,res0.weights,res0,gs_cfg);
