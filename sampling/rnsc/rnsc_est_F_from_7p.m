function varargout = rnsc_est_F_from_7p(u,s,threshold,confidence)
cfg.k = 7;
cfg.t = threshold;
cfg.confidence = confidence;
cfg.max_trials = 1e5;

cfg.sample_degen_fn = @eg_sample_degen;
cfg.sample_degen_args = { cfg.t, cfg.k };

% model functions
cfg.est_fn = @eg_est_F_from_7p;
cfg.error_fn = @(u,s,sample,F,cfg) sum(eg_sampson_err(u,s,sample,F,cfg).^2);

cfg = rnsc_standardize_cfg(cfg);

%cfg.lo = make_eg_inner_rnsc_cfg(cfg);
%cfg.lo.fn = @eg_inner_rnsc;
%
res = rnsc_estimate(u,s,cfg);

%cfg.model_args.model =  res.model;
%cfg.epsilon = 0;
%res = guided_sampling(blkdiag(T,T)*u, logical(res.weights), cfg);

%res.errors = sum(eg_sampson_err(u,res.model).^2);

varargout = { res };

if nargout == 2
    varargout = cat(2,varargout,cfg);
end