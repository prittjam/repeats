classdef GrSampler < handle
    properties
        groups
        N,p
        labeling
        freq
        
        min_trial_count = 10
        max_trial_count = 1e4
        confidence = 0.99

        G = []
        iif = []
    end
    
    methods
        function this = GrSampler(labeling,varargin)
            [this,~] = cmp_argparse(this,varargin{:});

            G = cmp_splitapply(@(g) { repmat(g(1),1,nchoosek(numel(g),2)) }, ...
                               labeling,labeling);            
            this.G = [ G{:} ];            
           
            this.N = numel(labeling);
            this.labeling = labeling;

            this.freq = hist(this.G,1:max(labeling));
            assert(all(this.freq > 0),'There are singeltons in the labeling!')

            this.p = this.freq/sum(this.freq);

            this.iif = @(x) make_iif(sum(x > 0) > 0, ...
                                     @() x, ...
                                     true, ...
                                     @() nan(1,numel(x)));
        end

        function num_responses = calc_num_responses(this) 
            num_responses = numel(this.G);
        end
            
        function s = sample(this,dr,k,varargin)
            s = zeros(1,this.N);

            while true
                c = find(mnrnd(2,this.p,1));
                if numel(unique(c)) == 2
                    break;
                end
            end

            idx = find(this.labeling == c(1));
            s(idx(randperm(numel(idx),k))) = 1;
            
            idx = find(this.labeling == c(2));
            s(idx(randperm(numel(idx),k))) = 2;            
        end
        
        function trial_count = update_trial_count(this,labeling0,cs)
            trial_count = inf;

            cs(cs == 0) = nan;
            cs_freq = hist(this.G.*cs,1:max(this.G));

            ind = this.freq > 0;
            p2 = hygepdf(1,this.freq(ind),cs_freq(ind),1);
            p3 = dot(this.p(ind),p2);
            
            N = ceil(log(1-this.confidence)/log(1-p3));
            ub = min([N this.max_trial_count]);
            trial_count = max([ub this.min_trial_count]);
        end

    end
end
