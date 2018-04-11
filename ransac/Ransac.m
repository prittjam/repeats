% Copyright (c) 2017 James Pritts
% 
classdef Ransac < handle
    properties 
        model
        sampler
        eval
        lo = []
    end
    
    methods
        function this = Ransac(model,sampler,eval,varargin)
            [this,~] = cmp_argparse(this,varargin{:});
            
            this.model = model;
            this.sampler = sampler;
            this.eval = eval;
        end
        
        function [loM,lo_res,lo_stats] = do_lo(this,x,corresp,M,res,varargin)
            loM = [];
            lo_res = [];
            if ~isempty(this.lo)
                [loM,lo_res] = this.lo.fit(x,corresp,M,res, ...
                                           varargin{:});
            end
        end

        function  [optM,opt_res,stats] = fit(this,x,corresp,varargin)
            tic;

            stats = struct('time_elapsed', 0, ...
                           'trial_count', 0, ...
                           'sample_count', 0, ...
                           'model_count', 0, ...
                           'lo', [], ...
                           'ransac', []);

            N = inf;
            res = struct('loss', inf, ...
                         'cs', 0);
            optM = [];
            lo_res = res;
            opt_res = res;
            
            has_model = false;
            while true         
                for k = 1:this.sampler.max_num_retries
                    idx = this.sampler.sample(x,corresp);
                    is_sample_good = ...
                        this.model.is_sample_good(x,corresp,idx);
                    if is_sample_good
                        try
                            model_list = this.model.fit(x, ...
                                                        corresp,idx, ...
                                                        varargin{:});
                        catch excpn
                            model_list = [];
                        end
                        if ~isempty(model_list)
                            has_model = true;
                            break;
                        end
                    end
                end
                assert(is_sample_good, ... 
                       'Could not draw a non-degenerate sample!'); 
                assert(has_model, ...
                       'Could not generate a model!');                     
                
                stats.sample_count = stats.sample_count+k;
                
                is_model_good = false(1,numel(model_list));

                for k = 1:numel(model_list)
                    is_model_good(k) = ...
                        this.model.is_model_good(x,corresp,idx,model_list(k));
                end
                
                if ~all(is_model_good)
                    bad_ind = find(~is_model_good);
                    for k = bad_ind
                        Mfix = this.model.fix(x,corresp,idx,model_list(k));
                        if ~isempty(Mfix)
                            is_model_good(k) = true;
                            model_list(k) = Mfix;
                        end
                    end
                    model_list = model_list(is_model_good);
                end

                if ~isempty(model_list)
                    stats.model_count = stats.model_count+numel(model_list);
                    loss = inf(numel(model_list),1);
                    for k = 1:numel(model_list)
                        [loss(k),err{k}] = this.eval.calc_loss(x,corresp,model_list(k));
                        cs{k} = this.eval.calc_cs(err{k});
                    end
                    [~,mink] = min(loss);
                    M0 = model_list(mink);
                    res0 = struct('err', err{mink}, ...
                                  'loss', loss(mink), ...
                                  'cs', cs{mink}, ...
                                  'mss', {idx});
                    if (sum(res0.cs) > 0) && ...
                            (res0.loss < res.loss) && ...
                            (sum(res0.cs) >= sum(res.cs))
                        M = M0;
                        res = res0;
                        stats.ransac = cat(2,stats.ransac, ...
                                           struct('M',M, ...
                                                  'res',res, ...
                                                  'model_count', stats.model_count, ...
                                                  'trial_count', stats.trial_count));
                        if res.loss < opt_res.loss
                            optM = M;
                            opt_res = res;
                        end
                        [loM,lo_res] = ...
                            this.do_lo(x,corresp,M0,res0,varargin{:});
                        lo_stats = struct('loM',loM, ...
                                          'lo_res',lo_res, ...
                                          'trial_count',stats.trial_count, ...
                                          'model_count',stats.model_count); ...
                            stats.lo = cat(2,stats.lo,lo_stats);

                        if (lo_res.loss < opt_res.loss)
                            optM = loM;
                            opt_res = lo_res;
                        end
                        % Update estimate of est_trial_count, the number
                        % of trial_count to ensure we pick, with
                        % probability p, a data set with no outliers.
                        N = this.sampler.update_trial_count(corresp,opt_res.cs);
                    end   
                end
                
                stats.trial_count = stats.trial_count+1;
                
                if (stats.trial_count >= N)
                    break;
                end
            end
            
            if numel(stats.lo) == 0
                stats.ransac = cat(2,stats.ransac, ...
                                   struct('M',M, ...
                                          'res',res, ...
                                          'model_count', stats.model_count, ...
                                          'trial_count', stats.trial_count));
                [loM,lo_res] = this.do_lo(x,corresp,M,res,varargin{:});
                lo_stats = struct('loM',loM, ...
                                  'lo_res',lo_res, ...
                                  'trial_count',stats.trial_count, ...
                                  'model_count',stats.model_count); 
                stats.lo = cat(2,stats.lo,lo_stats);
                if (lo_res.loss < opt_res.loss)
                    optM = loM;
                    opt_res = lo_res;
                end
            end
            
            stats.time_elapsed = toc;               
        end
    end
end
