function opt_res = rnsc_estimate(u,s,cfg)
tic;
error(nargchk(3,3,nargin));

tcCount = nnz(s);
p = cfg.confidence;   
N = cfg.max_trials;            

trials = 0;
sample_degen_count = 0;
loCount = 0;

best_res.score = -inf;
opt_res.score = -inf;

tic;

while trials < max([min([N cfg.max_trials]) cfg.min_trials 1]) 
    count = 0;
    is_sample_degen = true;

    while (is_sample_degen && ...
           (count < cfg.max_data_retries))
        sample = feval(cfg.sample_fn,u,s,cfg.k, ...
                       trials,cfg.sample_args{ : });
        is_sample_degen = feval(cfg.sample_degen_fn, ...
                                u,sample, ...
                                cfg.sample_degen_args{ : });
        if ~is_sample_degen
            model_list = feval(cfg.est_fn,u,sample, ...
                               cfg.est_args{ : });
            is_sample_degen = is_sample_degen || isempty(model_list);
        end
        count = count+1;
    end
    
    if (count == cfg.max_data_retries)
        error('Could not draw a non-degenerate sample!');
        break;
    end
    
    sample_degen_count = sample_degen_count+count;

    res = rnsc_get_best_model(u,s,sample,model_list,cfg);
    res.from_lo = false;

    if (res.score > best_res.score)
        best_res = res;

        if isfield(cfg,'model_degen')
            is_model_degen = feval(cfg.model_degen.detect_fn,u,sample, ...
                                   res.model,res.weights,cfg.model_degen);
            if is_model_degen
                model = feval(cfg.model_degen.fix_fn,u,res.weights, ...
                              cfg.model_degen);
                if isempty(model), continue, end;
                res = rnsc_get_best_model(u,model,cfg);
            end
        end
        
        if isfield(cfg, 'lo') && (trials > 10)
            res_lo = feval(cfg.lo.fn,u,s,sample, ...
                           res.weights,res.model,cfg.lo);
            if ~isempty(res_lo) % && (res_lo.score > res.score)
                loCount = loCount+1;
                res = res_lo;
            end              
        end

        if (res.score > opt_res.score) 
            opt_res = res;
        end

        opt_res.inliers_found = sum(res.weights);

        % Update estimate of N, the number of trials to ensure we pick,
        % with probability p, a data set with no outliers.
        fracinlying_set = opt_res.inliers_found/tcCount;
        pNoOutliers = 1-fracinlying_set^cfg.k;
        pNoOutliers = max(eps, pNoOutliers);  % Avoid division by -Inf
        pNoOutliers = min(1-eps, pNoOutliers);% Avoid division by 0.
        N = ceil(log(1-p)/log(pNoOutliers));
    end    
    trials = trials+1;
end

if isfield(cfg, 'lo') && (loCount == 0)
    res_lo = feval(cfg.lo.fn,u,s,sample, ...
                   opt_res.weights,opt_res.model,cfg.lo);
    if ~isempty(res_lo) % && (res_lo.score > res.score)
        loCount = loCount+1;
        opt_res = res_lo;
    else 
        opt_res.from_lo = false;
    end
end

opt_res.inliers_found = sum(opt_res.weights);    
opt_res.loCount = loCount;
opt_res.samples_drawn = trials;
opt_res.time_elapsed = toc;
opt_res.tcCount = tcCount;