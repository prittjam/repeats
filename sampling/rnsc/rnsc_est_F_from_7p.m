function varargout = rnsc_est_F_from_7p(u,s,sigma,confidence,sz1,sz2)
cfg.k = 7;
cfg.sigma = sigma;
cfg.tsq = 3.84*sigma^2;
cfg.confidence = confidence;
cfg.max_trials = 1e5;
cfg.sz1 = sz1;
cfg.sz2 = sz2;

%cfg.sample_degen_fn = @eg_sample_degen;
%cfg.sample_degen_args = { 5.99*sigma^2, cfg.k };
%
% model functions
cfg.est_fn = @eg_est_F_from_7p;
cfg.cost_fn = @robust_cost_fn;
cfg.objective_fn = @robust_objective_fn;

%orsa

cfg.orsa.sz1 = sz1;
cfg.orsa.sz2 = sz2;
cfg.orsa.tcCount = size(u,2);
cfg.orsa.k = 1;
cfg.orsa.num_solutions = 1;
cfg.orsa = orsa_precompute_nfa(cfg,sz1,sz2);

% model degen
cfg.model_degen.detect_fn = @eg_check_oriented;
cfg.model_degen.fix_fn = @eg_fix_oriented;

cfg = rnsc_standardize_cfg(cfg);

cfg.lo = make_lo_rnsc_cfg(cfg,sigma);

res = rnsc_estimate(u,s,cfg);

res.solver = 'F-7p-Jimmy';

varargout = { res };

if nargout == 2
    varargout = cat(2,varargout,cfg);
end

function cfg = make_lo_rnsc_cfg(cfg,sigma) 
cfg.fn = @fa_lo_est_F_new;
cfg.tsq = 3.84*sigma^2;

function C = robust_cost_fn(u,s,sample,F,cfg)
C = (eg_sampson_F_dist(u(:,s),F).^2/2/cfg.sigma).^2;
T = 9;
C(C > T) = T;

function [score weights] = robust_objective_fn(C,u,s,sample,cfg)
score = sum(sum(C));
weights = sum(C) < cfg.tsq;