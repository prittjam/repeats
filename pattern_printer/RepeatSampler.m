classdef RepeatSampler < handle
    properties
        min_trial_count = 50;
        max_trial_count = 250;
        max_num_retries = 100;
        
        confidence = 0.99
        N,p
        labeling0

        freq = []
        Z = []
        k = []
    end
    
    methods
        function this = RepeatSampler(x,k,Gsamp,varargin)
            this.labeling0 = findgroups(Gsamp);
            
            this.freq = hist(this.labeling0,1:max(this.labeling0));
            this.Z = arrayfun(@(z) nchoosek(z,2),this.freq);
            this.p = this.Z/sum(this.Z);
            this.N = sum(this.Z);
            this.k = k;
        end

        %        function idx = sample(this,x,corresp,varargin)
        %            while true
        %                idx = randsample(this.N,this.k);
        %                if (numel(unique(corresp(:,idx))) == 2*this.k) && ...
        %                    (numel(unique(this.labeling0(corresp(:,idx)))) == this.k)
        %                    break;
        %                end
        %            end
        %        end

        function idx = sample(this,x,varargin)
            [ii,jj] = find(mnrnd(1,this.p,numel(this.k)));
            jj(ii) = jj;
            for k = 1:numel(jj)
                ind = find(this.labeling0 == jj(k));
                idx{k} = ind(randperm(this.freq(jj(k)),this.k(k)));
            end
            %    for 
            %    
            %    while true
            %                idx = randsample(this.N,this.k);
            %                if (numel(unique(corresp(:,idx))) == 2*this.k) && ...
            %                    (numel(unique(this.labeling0(corresp(:,idx)))) == this.k)
            %                    break;
            %                end
            %            end
            %        end
            %
        end

        function trial_count = update_trial_count(this,corresp,cs)
            trial_count = inf;
            %            cslabeling = this.labeling0.*cs;
            %            cslabeling(find(cslabeling==0)) = nan;
            %            cs_freq = hist(cslabeling,1:max(this.labeling0));
            %            ind = cs_freq > 0;
            %            p2 = hygepdf(2,this.freq(ind),cs_freq(ind),2);
            %            p3 = dot(this.p(ind),p2);
            p3 = sum(cs)/this.N;

            if p3 > 0
                N = ceil(log(1-this.confidence)/log(1-p3^(sum(this.k))));
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
