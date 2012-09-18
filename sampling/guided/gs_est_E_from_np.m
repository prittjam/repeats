function varargout = eg_est_E_np_gs(u,s,E0)

cfg.min_trials = 1;
cfg.max_trials = 10; 
cfg.epsilon = eps;

cfg.est_fn = func2str(@eg_est_E_np_lsqnonlin);
cfg.est_args = { E0 };

cfg.error_fn = @(u,F) eg_sampson_err(u,F);

cfg.objective_fn = func2str(@rnsc_objective_fn);

[res,cfg] = guided_sampling(u,s,E0,cfg);

if nargout < 2
    varargout = { res };
else
    varargout = { res, cfg };
end