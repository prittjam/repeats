function varargout = rnsc_est_E_from_5p(u,threshold,confidence)
sample_set = true(1,size(u,2));

cfg.s = 5;
cfg.t = threshold;
cfg.confidence = confidence;
cfg.max_trials = 1e5;

% model functions
cfg.est_fn = @eg_est_E_from_5p_gb;
cfg.error_fn = @(u,F) sum(eg_sampson_err(u,F).^2);

% sampling degeneracy
cfg.sample_degen_fn = @eg_sample_degen;
cfg.sample_degen_args = { cfg.t, cfg.s };

% local optimzation
cfg.lo = rnsc_lo_make_est_E_from_np_cfg(cfg);
cfg.lo.fn = @rnsc_lo_est_E_from_np;

cfg = rnsc_standardize_cfg(cfg);

[res, cfg] = rnsc_estimate(u,sample_set,cfg);

%cfg.model_args.model =  res.model;
%cfg.epsilon = 0;
%res = guided_sampling(blkdiag(T,T)*u, logical(res.weights), cfg);

res.errors = sum(eg_sampson_err(u,res.model).^2);

varargout = { res };

if nargout == 2
    varargout = cat(2,varargout,cfg);
end