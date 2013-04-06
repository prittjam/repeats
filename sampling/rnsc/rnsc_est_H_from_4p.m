function varargout = rnsc_est_H_from_4p(u,sample_set,threshold, confidence)
[T,invT] = pt_make_hartley_xform(renormI([u(1:3,:) u(4:6,:)]));

cfg.k = 4;
cfg.t = threshold;
%cfg.t = pt_get_hartley_threshold(T,threshold);
cfg.confidence = confidence;
cfg.max_trials = 1e5;

cfg.sample_fn = @rnsc_samp_uniform;

%cfg.sample_degen_fn = @hg_sample_degen;
%cfg.sample_degen_args = { cfg.t };

cfg.est_fn = @hg_est_H_from_4p;
cfg.error_fn = @(u,s,sample,H) sum(hg_sampson_err(u(:,s),H).^2);

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