function opt_res = rnsc_estimate(u,cfg,sampling_seed)
error(nargchk(2,3,nargin));

if nargin < 3
    sampling_seed = randi(intmax('int32'),1);
end

tcCount = cfg.tcCount;
p = cfg.confidence;   
N = cfg.max_trials;            

trials = 0;
sample_degen_count = 0;
loCount = 0;
rejCount = 0;

best_res.labels = [];
opt_res.labels = [];

if cfg.compare(0,inf)
    best_res.score = inf
    opt_res.score = inf;
else
    best_res.score = -inf;
    opt_res.score = -inf;
end

modelCount = 0;

tic;

while (trials < max([min([N cfg.max_trials]) cfg.min_trials 1]))
    count = 0;
    trials = trials+1;
    while true
        [s,sampling_seed] = feval(cfg.sample_fn,u,cfg.k, ...
                                    sampling_seed,cfg.sample_args{:});
        is_sample_degen = feval(cfg.sample_degen_fn, ...
                                u,s, ...
                                cfg.sample_degen_args{ : });
        if ~is_sample_degen
            model_list = feval(cfg.est_fn,u,s, ...
                               cfg.est_args{ : });
            is_sample_degen = isempty(model_list);
        end
        count = count+1;
        if ~is_sample_degen || (count == cfg.max_data_retries)
            break;
        end
    end

    if (count == cfg.max_data_retries)
        error('Could not draw a non-degenerate sample!');
        break;
    end
    
    sample_degen_count = sample_degen_count+count;

    if isfield(cfg,'model_degen')
        is_model_degen = feval(cfg.model_degen.detect_fn,u,s, ...
                               model_list,cfg.model_degen);
        m2 = sum(is_model_degen);
        rejCount = rejCount+m2;
        if m2 > 0
            model_list = feval(cfg.model_degen.fix_fn,u,s, ...
                               model_list,is_model_degen, ...
                               cfg.model_degen);
            if isempty(model_list) 
                continue;
            end;
        end
    end
    
    modelCount = modelCount+numel(model_list);
    res = rnsc_get_best_model(u,s,model_list,cfg);
    res.from_lo = false;

    if feval(cfg.compare,res.score,best_res.score)
        best_res = res;
        % Needed for ICCVNZ paper
        %        res.score = msac_objective_fn(res.C,[],[],cfg);    
        if isfield(cfg, 'lo') && (trials >= 50)
            res_lo = feval(cfg.lo.fn,u,s,res.labels,res.model, ...
                           cfg.lo);
            if ~isempty(res_lo) && (res_lo.score < res.score)
                res_lo.from_lo = true;
                res = res_lo;
            end              

            if res.from_lo
                loCount = loCount+1;
            end
        end
        
        if feval(cfg.compare,res.score,opt_res.score)
            opt_res = res;
        end

        opt_res.inliers_found = nnz(res.labels);

        % Update estimate of N, the number of trials to ensure we pick,
        % with probability p, a data set with no outliers.
        %       fracinlying_set = opt_res.inliers_found/tcCount;
%        pNoOutliers = 1-fracinlying_set^cfg.k;
%        pNoOutliers = max(eps, pNoOutliers);  % Avoid division by -Inf
%        pNoOutliers = min(1-eps, pNoOutliers);% Avoid division by
%                                              % 0.
                                              %     N = ceil(log(1-p)/log(pNoOutliers));
        N = ceil(nsamples(opt_res.inliers_found,tcCount,cfg.k,p));
    end    
end

if isfield(cfg, 'lo') && (loCount == 0)
    res_lo = feval(cfg.lo.fn,u,best_res.s,best_res.labels, ...
                   best_res.model,cfg.lo,true);
    if ~isempty(res_lo) && feval(cfg.compare,res_lo.score, ...
                                 opt_res.score)
        res_lo.from_lo = true;
        opt_res = res_lo;
    end

    if opt_res.from_lo
        loCount = loCount+1;
    end
end

opt_res.time_elapsed = toc;

opt_res.inliers_found = sum(opt_res.labels);    
opt_res.samples_drawn = trials;
opt_res.modelCount = modelCount;
opt_res.tcCount = tcCount;
opt_res.rejCount = rejCount;
opt_res.loCount = loCount;