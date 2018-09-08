%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function res = rnsc_est_Hinf_from_3laf(u,sample_set,threshold,confidence)
cfg.k = 3;
cfg.t = threshold;
cfg.confidence = confidence;
cfg.max_trials = 1e5;
cfg.tcCount = nnz(sample_set);

% model functions
cfg.sample_fn = @rnsc_sample_s;
cfg.sample_args = { sample_set }; 

cfg.est_fn = @hg_est_Hinf_from_3laf;
cfg.cost_fn = @hg_calc_Hinf_scale;
cfg.objective_fn = @hg_calc_Hinf_score;
cfg.compare = @gt;
cfg.eval_set = sample_set;

cfg = rnsc_standardize_cfg(cfg);

cfg.model_degen.detect_fn = @hg_is_degen;
cfg.model_degen.fix_fn = @hg_fix_degen;

cfg.lo = hg_make_inner_rnsc_cfg(cfg);

res0 = rnsc_estimate(u,cfg);
H = {hg_est_Hinf_from_3laf(u,res0.labels)};
res1 = rnsc_get_best_model(u,res0.labels,H,cfg);

if cfg.compare(res0.score,res1.score);
    res = res0;
else
    res = res1;
end

function [s2,sampling_seed] = rnsc_sample_s(u,k,sampling_seed,varargin)
rng(sampling_seed);
sampling_seed = randi(intmax('int32'),1);

s = varargin{1};
cs = cumsum(sum(s,2));
cs = cs/cs(end);

while true
    r = rand(1);
    ind = find(cs < r);
    if isempty(ind)
        mx = 1;
    else
        mx = max(ind)+1;
    end
    ind = find(s(mx,:));

    if numel(ind) >= k
        break;
    end
end

mx = repmat(mx,1,k);
sam = randperm(numel(ind));
sam = sam(1:k);
s2 = sparse(mx,ind(sam),true,size(s,1),size(s,2));

function is_degen = hg_is_degen(u,s,H,cfg)
[~,jj] = find(s);
%[U,S,V] = svd(H);
%is_degen0 = abs(min(diag(S))/max(diag(S))) < 0.1;
is_degen0 = false;
dp = H(3,:)*reshape(u(:,jj),3,[]);
is_degen1 = any(dp/dp(1) <= 0);
is_degen = is_degen0 & is_degen1;

function model = hg_fix_degen(varargin)
model = [];

function err = hg_calc_Hinf_scale(u,sam,Hinf,cfg)
s = cfg.eval_set;
[m,n] = size(s);
valid_rows = find(any(s,2));
err = sparse([],[],[],m,n,false);
for row_ind = valid_rows'
    ind = find(s(row_ind,:));
    t_laf = laf_renormI(blkdiag(Hinf,Hinf,Hinf)*u(:,ind));
    err(row_ind,ind) = abs(laf_get_scale(t_laf));
end

function [utility,labels] = hg_calc_Hinf_score(sc,u,s,cfg)
[m,n] = size(sc);
ii = [];
jj = [];

check_rows = find(any(sc,2))';
for row_ind = check_rows
    ia = find(sc(row_ind,:));
    [inl,ninl] = scal_set(sc(row_ind,ia),cfg.t);
    pct = ninl/nnz(sc(row_ind,:));
    if pct > 0.5
        if nnz(sc(row_ind,:)) > 1
            ii = cat(1,ii,row_ind*ones(ninl,1));
            jj = cat(1,jj,ia(inl)');
        end
    end
end
labels = sparse(ii,jj,true(1,numel(jj)),m,n);
utility = nnz(labels);

function [inl,ninl] = scal_set(sc,thr)
sc(sc < 0) = inf;
rt = sc' * (1./sc);
rt = max(rt, rt');
v = rt < thr;
[ninl, ft] = max(sum(v));
inl = v(ft,:);
if ninl < 2
    ninl = 0;
    inl(:) = false;
end
ind = find(inl);

function cfg = hg_make_inner_rnsc_cfg(cfg) 
cfg.fn = @hg_inner_rnsc;
cfg.model_fn = @hg_est_Hinf_from_3laf;
cfg.min_trials = 10;
cfg.max_trials = 10;
cfg.max_data_retries = 1e2;
cfg.confidence = 0.99;

function res = hg_inner_rnsc(u,s,labels,model,cfg,varargin)
cfg.k = min([10 max(ceil(sum(labels,2)*0.75))]);
cfg.tcCount = nnz(labels);
cfg.sample_args = { labels };
if cfg.k > 3
    cfg.model_args = model;
    res = rnsc_estimate(u,cfg);
else
    res = [];
end