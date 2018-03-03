function varargout = rnsc_est_H_from_4p(u,sigma,confidence,sz1, ...
                                          sz2)

[T,invT] = pt_make_hartley_xform(renormI([u(1:3,:) u(4:6,:)]));
cfg.k = 4;

cfg.tsq = 5.99*sigma^2;
cfg.confidence = confidence;
cfg.min_trials = 1;
cfg.max_trials = 1e5;
cfg.v = u;

cfg.tcCount = size(u,2);
cfg.compare = @lt;

cfg.orsa.tcCount = cfg.tcCount;
cfg.orsa.k = 4;
cfg.orsa.num_solutions = 1;

cfg.orsa = orsa_precompute_nfa(cfg,sz1,sz2);
cfg.orsa.sz1 = sz1;
cfg.orsa.sz2 = sz2;
cfg.orsa.max_tsq = cfg.tsq;

% model functions
cfg.est_fn = @hg_est_H_from_4p;
cfg.cost_fn = @(u,H,cfg) eg_sampson_H_dist(cfg.v,H);
cfg.objective_fn = @orsa_objective_fn;

%cfg.sample_degen_fn = @hg_sample_degen;
%cfg.sample_degen_args = { cfg.t };

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