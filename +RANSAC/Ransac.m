% Copyright (c) 2017 James Pritts
% 
classdef Ransac < handle
    properties 
        model
        sampler
        eval
        lo = []
    end
    
    properties
        p = 0.99;
        
        max_num_retries = 100;
       
        stats = struct('time_elapsed', 0, ...
                       'trial_count', 0, ...
                       'sample_count', 0, ...
                       'model_count', 0, ...
                       'lo_count', 0);

        K = [];
    end 
    
    methods
        function this = Ransac(model,sampler,eval,varargin)
            [this,~] = cmp_argparse(this,varargin{:});
            
            this.model = model;
            this.sampler = sampler;
            this.eval = eval;
        end
        
        function res = calc_res(this,meas,corresp,M)
            loss = inf(numel(M),1);
            err = inf(numel(M),this.K);
            cs = nan(numel(M),this.K);

            for k = 1:numel(M)
                [loss(k),err(k,:)] = this.eval.calc_loss(meas,corresp,M{k});
                cs(k,:) = this.eval.calc_cs(err);
            end
            
            [~,mink] = min(loss);
        
            res = struct('M', M{k}, 'err', err(k,:), ...
                         'loss', loss(k), 'cs', cs(k,:));
        end
        
        function lo_res = do_lo(this,meas,corresp,res)
            M = this.lo.fit(meas,corresp,res);
            lo_res = this.calc_res(meas,corresp,M);
            this.stats.lo_count = this.stats.lo_count+1;
        end

        function  [optM,opt_res,stats] = fit(this,meas,corresp)
            tic;

            this.stats = struct('time_elapsed', 0, ...
                                'trial_count', 0, ...
                                'sample_count', 0, ...
                                'model_count', 0, ...
                                'lo_count', 0);

            this.K = this.sampler.calc_num_responses();
            N = inf;

            res = struct('loss', inf, ...
                         'cs', zeros(1,numel(corresp)));
            lo_res = res;
            opt_res = res;

            has_model = false;
            while true         
                for k = 1:this.max_num_retries
                    idx = this.sampler.sample(meas,this.model.mss);
                    is_sample_good = ...
                        this.model.is_sample_good(meas,corresp,idx);
                    if is_sample_good
                        M = this.model.fit(meas,corresp,idx);
                        if ~isempty(M)
                            has_model = true;
                            break;
                        end
                    end
                end
                
                assert(is_sample_good, ...
                       'Could not draw a non-degenerate sample!'); 
                assert(has_model, ...
                       'Could not generate a model!');                     
                    
                this.stats.sample_count = this.stats.sample_count+k;
                
                model_count = 0;
                is_model_good = this.model.is_sample_good(meas,corresp,idx);

                if sum(~is_model_good) > 0
                    M = this.model.fix(meas,corresp,M(~is_model_good));
                    if isempty(M) 
                        continue;
                    end;
                end

                this.stats.model_count = this.stats.model_count+numel(M);

                loss = inf(numel(M),1);

                err = inf(numel(M),this.K);
                cs = nan(numel(M),this.K);

                for k = 1:numel(M)
                    [loss(k),err(k,:)] = ...
                        this.eval.calc_loss(meas,corresp,M{k});
                    cs(k,:) = this.eval.calc_cs(err(k,:));
                end
                
                [~,mink] = min(loss);
                
                res0 = struct('M', M{mink}, 'err', err(mink,:), ...
                              'loss', loss(mink), 'cs', cs(mink,:));

                if (sum(res0.cs) > 0) && ...
                        (res0.loss < res.loss) && ...
                        (sum(res0.cs) >= sum(res.cs))
                    old_res = res;
                    res = res0;
                    if res.loss < opt_res.loss
                        opt_res = res;
                    end
                    
                    if ~isempty(this.lo) && (this.stats.trial_count >= 50)
                        lo_res = this.do_lo(meas,corresp,res);
                    end
                    
                    if lo_res.loss < opt_res.loss
                        opt_res = lo_res;
                    end
                    
                    % Update estimate of est_trial_count, the number
                    % of trial_count to ensure we pick, with
                    % probability p, a data set with no outliers.
                    N = this.sampler.update_trial_count(corresp,opt_res.cs);
                end   
                
                this.stats.trial_count = this.stats.trial_count+1;
                
                if (this.stats.trial_count >= N)
                    break;
                end
            end
            
            if ~isempty(this.lo) && (this.stats.lo_count == 0)
                opt_res = this.do_lo(meas,corresp,res);
            end

            optM = opt_res.M;
            this.stats.time_elapsed = toc;               
            stats = this.stats;
        end
    end
end
