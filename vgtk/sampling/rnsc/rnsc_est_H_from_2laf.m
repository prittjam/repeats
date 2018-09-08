%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [res,cfg] = rnsc_est_H_from_2laf(u,sample_set,threshold,confidence)
cfg.k = 2;
cfg.t = threshold;
%cfg.t = pt_get_hartley_threshold(T,threshold);
cfg.confidence = confidence;
cfg.max_trials = 1e3;

cfg.sample_fn = @rnsc_samp_uniform;

%cfg.sample_degen_fn = @hg_sample_degen;
%cfg.sample_degen_args = { cfg.t };

cfg.est_fn = @hg_est_H_from_2laf;
%cfg.error_fn = @(u,s,sample,H) sum(hg_sampson_err(u(:,s),H).^2);
cfg.error_fn = @error_fn;

cfg = rnsc_standardize_cfg(cfg);

%cfg.lo = hg_make_inner_rnsc_cfg(cfg);
%cfg.lo.fn = @hg_inner_rnsc;

%un = blkdiag(T,T)*u;
res = rnsc_estimate(u,sample_set,cfg);

%cfg.epsilon = 0;
%cfg.model_args.model = res.model;
%res = guided_sampling(un,logical(res.weights),cfg);
%
%res.model = invT*res.model*T;

varargout = { res };

if nargout == 2
    varargout = cat(2,varargout,cfg);
end

function err = error_fn(v,s,sample,H)
v2 = v(:,s);
v3 = reshape(v2([1:3 10:12 4:6 13:15 7:9 16:18],:),6,[]);
err = max(reshape(sum(hg_sampson_err(v3,H).^2,1),3,[]));