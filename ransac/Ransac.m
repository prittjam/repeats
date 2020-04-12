% Copyright (c) 2017 James Pritts
% 
classdef Ransac < handle
    properties 
        solver
        sampler
        eval
        lo = []
    end
    
    methods
        function this = Ransac(solver,sampler,eval,varargin)
            [this,~] = cmp_argparse(this,varargin{:});
            
            this.solver = solver;
            this.sampler = sampler;
            this.eval = eval;
        end
        
        function [loM,lo_res,lo_stats] = do_lo(this,x,M,res,varargin)
            loM = [];
            lo_res = [];
            if ~isempty(this.lo)
                [loM,lo_res] = this.lo.fit(x,M,res,varargin{:});
            end
        end

        function  [optM,opt_res,stats] = fit(this,x,varargin)
            tic;
            max_loss = this.eval.calc_max_loss(x,varargin{:});
            stats = struct('time_elapsed', 0, ...
                           'trial_count', 1, ...
                           'N', inf,...
                           'sample_count', 0, ...
                           'model_count', 0, ...
                           'max_loss', max_loss, ...
                           'local_list', [], ...
                           'global_list', []);

           res = struct('loss', inf, ...
                         'cs', 0);
            optM = [];
            lo_res = res;
            opt_res = res;
            
            has_model = false;
            while true         
                for k = 1:this.sampler.max_num_retries
                    idx = this.sampler.sample(x);
                    is_sample_good = ...
                        this.solver.is_sample_good(x,idx);
                    if is_sample_good
                        try
                            model_list = this.solver.fit(x,idx,varargin{:});
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
                        this.solver.is_model_good(x,idx,model_list(k),varargin{:});
                end

                if ~all(is_model_good)
                    bad_ind = find(~is_model_good);
                    for k = bad_ind
                        Mfix = this.solver.fix(x,idx,model_list(k),varargin{:});
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
                        [loss(k),err{k},cs{k},loss_info{k}] = ...
                            this.eval.calc_loss(x,model_list(k),varargin{:});
                    end
                    [~,mink] = min(loss);
                    M0 = model_list(mink);
                    res0 = struct('err', err{mink}, ...
                                  'loss', loss(mink), ...
                                  'cs', cs{mink}, ...
                                  'info', loss_info(mink), ...
                                  'mss', {idx});
                    if (sum(res0.cs) > 0) && ...
                            (res0.loss < res.loss) && ...
                            (sum(res0.cs) >= sum(res.cs))
                        M = M0;
                        res = res0;
                        stats.global_list = cat(2,stats.global_list, ...
                                                struct('model',M, ...
                                                       'res',res, ...
                                                       'model_count', stats.model_count, ...
                                                       'trial_count', stats.trial_count));
                        if res.loss < opt_res.loss
                            optM = M;
                            opt_res = res;
                        end
                        
                        [loM,lo_res] = this.do_lo(x,M0,res,varargin{:});
                        lo_stats = struct('model',loM, ...
                                          'res',lo_res, ...
                                          'trial_count',stats.trial_count, ...
                                          'model_count',stats.model_count);
                        
                        %                        assert(lo_res.loss <= res.loss,['likelihood decreased!']);
                        
                        if (lo_res.loss <= opt_res.loss)
                            stats.local_list = cat(2,stats.local_list,lo_stats);
                            optM = loM;
                            opt_res = lo_res;
                            opt_res.loss
                        end
                        
                        if numel(stats.local_list) > 1
                            if (stats.local_list(end).res.loss- ...
                                stats.local_list(end-1).res.loss > 0)
                                keyboard;
                            end
%                            assert(stats.local_list(end)- ...
%                                   stats.local_list(end-1) < 0, ...
%                                   ['likelihood decreased!']);
                        end                        
                        % Update estimate of est_trial_count, the number
                        % of trial_count to ensure we pick, with
                        % probability p, a data set with no outliers.
                        stats.N = this.sampler.update_trial_count(opt_res.cs);
                    end   
                end
                    
                stats.trial_count = stats.trial_count+1;
                disp(['Trial '  num2str(stats.trial_count) ' out of ' num2str(stats.N)]); 

                if (stats.trial_count >= stats.N)
                    break;
                end
            end

            stats.time_elapsed = toc;               
        end
    end
end
