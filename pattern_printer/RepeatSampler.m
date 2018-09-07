classdef RepeatSampler < handle
    properties
        min_trial_count = 50;
        max_trial_count = 750;
        max_num_retries = 100;
        
        confidence = 0.99
        N,p
        labeling0

        freq = []
        mss = []
        pmap = containers.Map('KeyType','double','ValueType','any');
    end
    
    methods
        function this = RepeatSampler(x,mss,Gsamp,varargin)
            this.labeling0 = findgroups(Gsamp);
            this.freq = hist(this.labeling0,1:max(this.labeling0));
            this.mss = mss; 
            umss = unique(mss);

 
            for k = 1:numel(umss)
                is_good = this.freq >= umss(k); 
                Z = zeros(1,numel(this.freq));
                Z(is_good) = arrayfun(@(z) nchoosek(z,umss(k)), ...
                                      this.freq(is_good)); 
                this.pmap(umss(k)) = Z/sum(Z);
            end
        end

        function idx = sample(this,x,varargin)
            [G,id] = findgroups(this.mss); 
            keyboard;
            keep_trying = true; 
            while keep_trying
                s = splitapply(@(x) { mnrnd(numel(x),this.pmap(x(1)),1) }, ...
                               this.mss,G);
                for k = 1:numel(id)
                    labels = s{k};
                    ind = find(labels);
                    replabel = repelem(ind,labels(ind));
                    for k2 = 1:numel(replabel)
                        good_idx = find(this.labeling0 == replabel(k2));
                        perm_idx = randperm(numel(good_idx),id(k));
                        idx{k} = good_idx(perm_idx);
                    end
                end
                [~,ia] = ismember(this.mss,id);
                idx = idx(ia);
                
            end
        end

        function trial_count = update_trial_count(this,cspond,cs)
            trial_count = inf;
            %            cslabeling = this.labeling0.*cs;
            %            cslabeling(find(cslabeling==0)) = nan;
            %            cs_freq = hist(cslabeling,1:max(this.labeling0));
            %            ind = cs_freq > 0;
            %            p2 = hygepdf(2,this.freq(ind),cs_freq(ind),2);
            %            p3 = dot(this.p(ind),p2);
            p3 = sum(cs)/size(cspond,2);

            if p3 > 0
                N = ceil(log(1-this.confidence)/log(1-p3^(sum(this.mss))));
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
