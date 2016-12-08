classdef GrSampler < handle
    properties
        groups
        N,p
        labeling
        freq;
        
        min_trial_count = 10;
        max_trial_count = 1e4;
        confidence = 0.99;

        iif = []; 
    end
    
    methods
        function this = GrSampler(labeling,varargin)
            [this,~] = cmp_argparse(this,varargin{:});
            
            this.N = numel(labeling);
            this.labeling = labeling;
            this.freq = hist(labeling,1:max(labeling));
            this.freq(this.freq < 3) = 0;

            this.p = this.freq/sum(this.freq);
            
            this.iif = @(x) make_iif(sum(x > 0) > 2, ...
                                     @() x, ...
                                     true, ...
                                     @() nan(1,numel(x)));
        end

        function s = sample(this,dr,k,varargin)
            s = zeros(1,this.N);
            c = find(mnrnd(1,this.p,1));
            idx = find(this.labeling == c);
            s(idx(randperm(numel(idx),k))) = 1;
        end
        
        function trial_count = update_trial_count(this,labeling0,cs)
            trial_count = inf;
            labeling0(labeling0 == 0) = nan;
            labeling = labeling0.*cs;
            labeling(labeling == 0) = nan;

            if any(isfinite(labeling))
                freq = hist(labeling,1:max(labeling));
                labeling = msplitapply(this.iif,labeling,findgroups(labeling));
                cs_freq = hist(labeling,1:max(labeling0));

                ind = this.freq > 0;
                p2 = hygepdf(3,this.freq(ind),cs_freq(ind),3);
                p3 = dot(this.p(ind),p2);
                
                N = ceil(log(1-this.confidence)/log(1-p3));
                ub = min([N this.max_trial_count]);
                trial_count = max([ub this.min_trial_count]);
            end
        end
    end
end
