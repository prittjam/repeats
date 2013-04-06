function res = rnsc_est_Hinf_from_3laf(u,sample_set,threshold,confidence)
cfg.k = 3;
cfg.t = threshold;
cfg.confidence = confidence;
cfg.max_trials = 1e5;

% model functions
cfg.sample_fn = @rnsc_sample_s;
cfg.est_fn = @hg_est_Hinf_from_3laf;
cfg.error_fn = @hg_calc_Hinf_scale;
cfg.objective_fn = @hg_calc_Hinf_score;

cfg = rnsc_standardize_cfg(cfg);

cfg.lo = hg_make_inner_rnsc_cfg(cfg);
cfg.lo.fn = @hg_inner_rnsc;

%cfg.model_degen.detect_fn = @hg_is_degen;
%cfg.model_degen.fix_fn = @hg_fix_degen;
%
% sampling

res = rnsc_estimate(u,sample_set,cfg);
res.weights = sparse(logical(res.weights));

function s2 = rnsc_sample_s(u,s,k,varargin)
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
ib = ind(sam);

s2 = sparse(mx,ib,true,size(s,1),size(s,2));

function is_degen = hg_is_degen(u,s,H,weights,cfg)
[U,S,V] = svd(H);
is_degen = abs(max(diag(S))/min(diag(S))) > 10;

function model = hg_fix_degen(varargin)
model = [];

function err = hg_calc_Hinf_scale(u,s,sample,Hinf,cfg)
[m,n] = size(s);
valid_rows = find(any(s,2));
err = sparse([],[],[],m,n,false);
for row_ind = valid_rows'
    ind = find(s(row_ind,:));
    t_laf = laf_renormI(blkdiag(Hinf,Hinf,Hinf)*u(:,ind));
    err(row_ind,ind) = laf_get_scale_from_3p(t_laf);
end

function [utility,vis2] = hg_calc_Hinf_score(sc,u,s,sample,t)
[m,n] = size(sc);
ii = [];
jj = [];

check_rows = find(any(sc,2))';
for row_ind = check_rows
    ia = find(sc(row_ind,:));
    [inl,ninl] = scal_set(sc(row_ind,ia),t);
    pct = ninl/nnz(sc(row_ind,:));
    %    if pct > 0.25
    if nnz(sc(row_ind,:)) > 1
        ii = cat(1,ii,row_ind*ones(ninl,1));
        jj = cat(1,jj,ia(inl)');
    end
end
vis2 = sparse(ii,jj,true(1,numel(jj)),m,n);
utility = nnz(vis2);

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
sparse(ones(1,numel(ind)), ...
       ind,true(1,numel(ind)),1,numel(inl));

function cfg = hg_make_inner_rnsc_cfg(cfg) 
cfg.model_fn = @hg_est_Hinf_from_3laf;
cfg.min_trials = 10;
cfg.max_trials = 10;
cfg.max_data_retries = 1e2;
cfg.confidence = 0.99;

function res = hg_inner_rnsc(u,s,weights,model,cfg)
cfg.k = min([10 max(floor(sum(weights,2)/2))]);

if cfg.k > 4
    cfg.model_args = model;
    res = rnsc_estimate(u,weights,cfg);
else
    res = [];
end