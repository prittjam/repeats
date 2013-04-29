function varargout = rnsc_est_F_from_7p(u,s,sigma,confidence)
cfg.k = 7;
cfg.tsq = 3.84*sigma^2;
cfg.confidence = confidence;
cfg.max_trials = 1e5;

cfg.sample_degen_fn = @eg_sample_degen;
cfg.sample_degen_args = { 5.99*sigma^2, cfg.k };

% model functions
cfg.est_fn = @eg_est_F_from_7p;
cfg.error_fn = @(u,s,sample,F,cfg) sum(eg_sampson_err(u,s,sample,F,cfg).^2);

cfg = rnsc_standardize_cfg(cfg);

cfg.lo = make_lo_rnsc_cfg(cfg);

res = rnsc_estimate(u,s,cfg);

res.estimator = 'F-7p-Jimmy';

varargout = { res };

if nargout == 2
    varargout = cat(2,varargout,cfg);
end

function cfg = make_lo_rnsc_cfg(cfg) 
cfg.fn = @rnsc_lo_est_F_bmvc12;