function res = gs_estimate(u,s,res,cfg)
    samples_drawn = 0;

    md = 1.4826*median(abs(res.errors(s)-median(res.errors(s))));

    cfg.t = sqrt(2*md);
    cfg.objective_args = { cfg.t } ;

    res = rnsc_get_best_model(u,res.model,cfg);
    score0 = -inf;
    score = res.score;

    tic;

    while (samples_drawn < max([cfg.min_trials 1])) ...
            && (samples_drawn < cfg.max_trials) ...
            && (score-score0 > cfg.epsilon)
    
        M = feval(cfg.est_fn,u,s,res.model);
        res = rnsc_get_best_model(u,res.model,cfg);
        
        md = 1.4826*median(abs(res.errors(s)-median(res.errors(s))));

        cfg.t = sqrt(3*md);
        cfg.objective_args = { cfg.t } ;

        score0 = score;
        score = res.score;
        samples_drawn = samples_drawn+1;
        disp(['Guided sampling #' num2str(samples_drawn) ' found ' ...
              num2str(score) ' number of inliers.']);
    end
    
    res.us_time_elapsed = toc;    
    res.samples_drawn = samples_drawn;