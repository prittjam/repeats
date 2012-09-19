function opt_res = rnsc_estimate(u,sample_set,cfg,conn,rnsc_id)
    error(nargchk(3, 5, nargin));
    
    K = size(u,2);
    p = cfg.confidence;   
    t = cfg.t;
    N = cfg.max_trials;            

    sample_degen_count = 0;
    samples_drawn = 0;
    num_points = sum(sample_set);
    ia = find(sample_set > 0);

    best_res.score = -inf;
    opt_res.score = -inf;

    tic;
    
    while samples_drawn < max([min([N cfg.max_trials]) cfg.min_trials 1]) 
        count = 0;
        is_sample_degen = true;

        while (is_sample_degen && ...
               (count < cfg.max_data_retries))
            ind = feval(cfg.sample_fn,num_points,cfg.s, ...
                        samples_drawn,cfg.sample_args{ : });
            sample = false(1,K);
            sample(ia(ind)) = true;
            is_sample_degen = feval(cfg.sample_degen_fn, ...
                                    u, sample, ...
                                    cfg.sample_degen_args{ : });
            if ~is_sample_degen
                model_list = feval(cfg.est_fn,u,sample, ...
                                   cfg.est_args{ : });
                is_sample_degen = is_sample_degen | isempty(model_list);
            end
            count = count+1;
        end
        
        if (count == cfg.max_data_retries)
            error('Could not draw a non-degenerate sample!');
            break;
        end
        
        sample_degen_count = sample_degen_count+count;

        res = rnsc_get_best_model(u,model_list,cfg);

        if (res.score > best_res.score)
            best_res = res;

            if isfield(cfg, 'degen')
                is_model_degen = feval(cfg.model_degen.detect_fn,u,sample, ...
                                       res.weights, cfg.degen);
                if is_model_degen
                    model = feval(cfg.model_degen.fix_fn,u,res.weights, ...
                                  cfg.model_degen);
                    res = rnsc_get_best_model(u,model,cfg);
                end
            end
            
            if isfield(cfg, 'lo')
                res = feval(cfg.lo.fn,u,res.weights,res.model,cfg.lo);
            end

            if (res.score > opt_res.score)
                opt_res = res;
            end

            % Update estimate of N, the number of trials to ensure we pick,
            % with probability p, a data set with no outliers.
            fracinlying_set = opt_res.score/num_points;
            pNoOutliers = 1-fracinlying_set^cfg.s;
            pNoOutliers = max(eps, pNoOutliers);  % Avoid division by -Inf
            pNoOutliers = min(1-eps, pNoOutliers);% Avoid division by 0.
            N = ceil(log(1-p)/log(pNoOutliers));
        end    

        samples_drawn = samples_drawn+1;
    end