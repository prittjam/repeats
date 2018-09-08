%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function varargout = rt_rnsc_p3(u,threshold,confidence)
sample_set = ones(1,size(u,2));

cfg.s = 3;
cfg.t = threshold;
cfg.confidence = confidence;
cfg.max_trials = 1e5;

% model functions
cfg.est_fn = @rt_est_3p;
cfg.error_fn = @(Xc,u) sum(rt_reproj_err(Xc,u).^2);

cfg.sample_degen_fn = @(u,sample_set,varargin) pt_corr_is_injective(u,sample_set,varargin{ : });
cfg.sample_degen_args = { cfg.t };

cfg = rnsc_standardize_cfg(cfg);

[res, cfg] = rnsc_estimate(u,sample_set,cfg);

res.errors = feval(cfg.error_fn, ...
                   sum(rt_reproj_err(res.model,u).^2));

varargout = { res };

if nargout == 2
    varargout = cat(2,varargout,cfg);
end