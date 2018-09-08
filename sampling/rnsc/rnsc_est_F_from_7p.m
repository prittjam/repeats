%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function varargout = rnsc_est_F_from_7p(u,sigma,confidence,sz1,sz2)
N = size(u,2);
cfg.k = 7;

cfg.tsq = 3.84*sigma^2;
cfg.confidence = confidence;
cfg.min_trials = 1;
cfg.max_trials = 1e5;
cfg.v = u;

cfg.tcCount = N;
cfg.compare = @lt;

cfg.orsa.tcCount = cfg.tcCount;
cfg.orsa.k = cfg.k;
cfg.orsa.num_solutions = 3;

cfg.orsa = orsa_calc_eg_nfa(cfg,sz1,sz2);
cfg.orsa.sz1 = sz1;
cfg.orsa.sz2 = sz2;
cfg.orsa.max_tsq = 10*cfg.tsq;

% model functions
cfg.est_fn = @eg_est_F_from_7p;
cfg.cost_fn = @(u,s,F,cfg) eg_sampson_F_dist(u,F);
cfg.objective_fn = @orsa_objective_fn;

cfg = rnsc_standardize_cfg(cfg);
cfg.lo = make_lo_rnsc_cfg(sigma,cfg);

tic;
res = rnsc_estimate(u,cfg);
res.time_elapsed = toc;

res.solver = 'F-7p-Jimmy';
res.tcCount = N;

varargout = { res };

if nargout == 2
    varargout = cat(2,varargout,cfg);
end

function cfg = make_lo_rnsc_cfg(sigma,cfg) 
cfg.fn = @fa_lo_est_F_bmvc12;
cfg.tsq = 3.84*sigma^2;

%function C = robust_cost_fn(u,s,sample,F,cfg)
%C = (eg_sampson_F_dist(u(:,s),F).^2/2/cfg.sigma).^2;
%T = 9;
%C(C > T) = T;
%
%function [score weights] = robust_objective_fn(C,u,s,sample,cfg)
%score = sum(sum(C));
%weights = sum(C) < cfg.tsq;