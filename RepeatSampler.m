classdef RepeatSampler < handle
    properties
        min_trial_count = 100;
        max_trial_count = 1e4;
        max_num_retries = 100;
        
        confidence = 0.99
        
        N,p
        labeling0

        freq = []
        Z = []
        k = []
    end
    
    methods
        function this = RepeatSampler(dr,corresp,k,varargin)
            [this,~] = cmp_argparse(this,varargin{:});

            this.labeling0 = [dr(:).Gsamp];
            
            this.freq = hist(this.labeling0,1:max(this.labeling0));
            this.Z = arrayfun(@(x) nchoosek(x,2),this.freq);
            this.p = this.Z/sum(this.Z);
            this.N = sum(this.Z);
            this.k = k;
            
            assert(this.N == size(corresp,2), ...
                   'Number of total correspondences is incorrect');
        end

        function idx = sample(this,dr,corresp,varargin)
            while true
                idx = randsample(this.N,this.k);
                if numel(unique(corresp(:,idx))) == 2*this.k
                    break;
                end
            end
        end
        
        function trial_count = update_trial_count(this,corresp,cs)
            trial_count = inf;
            cslabeling = this.labeling0.*cs;
            cslabeling(find(cslabeling==0)) = nan;
            cs_freq = hist(cslabeling,1:max(this.labeling0));
            ind = cs_freq > 0;
            p2 = hygepdf(2,this.freq(ind),cs_freq(ind),2);
            p3 = dot(this.p(ind),p2);
            
            if p3 > 0
                N = ceil(log(1-this.confidence)/log(1-p3^(this.k)));
            else
                N = inf;
            end
            
            ub = min([N this.max_trial_count]);
            trial_count = max([ub this.min_trial_count]);

            eip = p3*100;
            disp(['Expected inlier percentage: ' num2str(eip,'%04.1f') ...
                  ' |  # trials needed: ' num2str(trial_count)]);
        end
    end
end 
