classdef ElationSampler < handle
    properties
        N
        
        min_trial_count = 100;
        max_trial_count = 1e3;
        confidence = 0.99;
        max_num_retries = 100;
    end
    
    methods
        function this = ElationSampler(dr,corresp,k,varargin)
            [this,~] = cmp_argparse(this,varargin{:});
            this.k = k;
            this.N = size(corresp,2);
        end

        function ind = sample(this,dr,k,varargin)
            while true
                ind = reshape(randsample(this.N,2),1,[]);
                if numel(unique(ind)) == 2
                    break
                end
            end
        end
        
        function trial_count = update_trial_count(this,corresp,cs)
            trial_count = inf;
            w = sum(cs)/this.N;

            assert(w > 0,'There are no inliers!');
            
            N = ceil(log(1-this.confidence)/log(1-w^this.k));
            ub = min([N this.max_trial_count]);
            trial_count = max([ub this.min_trial_count]);
            
            disp(['Inlier percentage: ' num2str(w*100,'%2.2f') ' |  # trials needed: ' ...
                  num2str(trial_count)]);
        end
    end
end
