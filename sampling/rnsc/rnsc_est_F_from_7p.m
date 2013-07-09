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

% model degen
cfg.model_degen.detect_fn = @eg_F_model_check;
cfg.model_degen.fix_fn = @eg_F_fix;

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

function is_degen = eg_F_model_check(u,s,sample,weights,F, ...
                                    cfg)
m = numel(F);
is_degen = false(1,m);
for k = 1:m
    is_good = eg_check_orientation(u(:,sample),F{k});
    is_degen(k) = ~is_good;
end

function model_list = eg_F_fix(u,s,sample,weights,degen_model_list,is_model_degen,cfg)
model_list = {};
for k = 1:numel(is_model_degen)
    if ~is_model_degen(k)
        model_list = cat(2,model_list,degen_model_list{k});
    end
end

function is_good = eg_check_orientation(u,F)
[U,D,V] = svd(F,0);
e2 = renormI(U(:,3));
is_good = ...
    all(all(sign(cross(repmat(e2,1,size(u,2)),u(4:6,:))./(F*u(1:3,:)))==1));

function C = robust_cost_fn(u,s,sample,F,cfg)
C = (eg_sampson_F_dist(u(:,s),F).^2/2/cfg.sigma).^2;
T = 9;
C(C > T) = T;

function [score weights] = robust_objective_fn(C,u,s,sample,cfg)
score = sum(sum(C));
weights = sum(C) < cfg.tsq;