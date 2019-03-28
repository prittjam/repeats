%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef RepeatSampler < handle
    properties
        min_trial_count = 50;
        max_trial_count = 500;
        max_num_retries = 200;
        
        confidence = 0.99
        N,p
        labeling0

        freq = []
        mss = []
        pmap = containers.Map('KeyType','double','ValueType','any');
    end
    
    methods
        function this = RepeatSampler(x,mss,G,varargin)
        % handle problems with reflections!
            is_ccwise = PT.is_ccwise(x);            
            G(is_ccwise) = findgroups(G(is_ccwise));
            G(~is_ccwise) = findgroups(G(~is_ccwise))+max(G(is_ccwise));
            this.labeling0 = findgroups(G);
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
            [smss,inda] = sort(this.mss);
            [G,id] = findgroups(findgroups(smss));
            keep_trying = true; 

            idx = {};
            s = splitapply(@(x) { mnrnd(numel(x),this.pmap(x(1)),1) }, ...
                           smss,G);
            k3 = 1;               
            for k = 1:numel(id)
                labels = s{k};
                ind = find(labels);
                replabel = repelem(ind,labels(ind));
                for k2 = 1:numel(replabel)
                    good_idx = find(this.labeling0 == replabel(k2));
                    perm_idx = randperm(numel(good_idx),smss(k));
                    idx{k3} = good_idx(perm_idx);
                    k3 = k3+1;
                end
            end

            idx(inda) = idx;
        end

        function trial_count = update_trial_count(this,cs)
%            trial_count = inf;
%            cslabeling = this.labeling0.*cs;
%            cslabeling(find(cslabeling==0)) = nan;
%            cs_freq = hist(cslabeling,1:max(this.labeling0));
%            ind = cs_freq > 0;
%            p2 = hygepdf(2,this.freq(ind),cs_freq(ind),2);
%            p3 = dot(this.p(ind),p2);
%            %            p3 = sum(cs)/size(cspond,2);
%
%            if p3 > 0
%                N = ceil(log(1-this.confidence)/log(1-p3^(sum(this.mss))));
%            else
%                N = inf;
%            end
%            
%            ub = min([N this.max_trial_count]);
%            trial_count = max([ub this.min_trial_count]);
%
%            eip = p3*100;
%            disp(['Expected inlier percentage: ' num2str(eip,'%04.1f') ...
%                  ' |  # trials needed: ' num2str(trial_count)]);
    trial_count = 100;
        end
    end
end 
