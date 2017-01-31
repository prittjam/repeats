classdef GrEval < handle
    properties    
        T = log(1.3/1.0);
        linkage_method = 'complete';
        iff = [];
        err_type = 'cviu16';
        motion_model = @laf2xN_to_RtxN;
    end

    methods
        function this = GrEval(varargin)
            [this,~] = cmp_argparse(this,varargin{:});
            this.iff = @(x) make_iif(sum(x < this.T) > 1, ...
                                     @() x < this.T, ...
                                     true, ...
                                     @() false(1,numel(x)));
        end
        
        function [cs,err] = calc_cviu16_objective(this,dr,G,H)
            cs = nan(1,numel(dr));
            err = zeros(1,numel(dr));
            u = [dr(:).u];
            ind = 1:size(u,2);
            [cs0,idx] = ...
                cmp_splitapply(@(x,y) ...
                               deal({calc_pwise_utility(x,H,this.motion_model)},{y}), ...
                               u,ind,findgroups(G));            
            cs([idx{:}]) = [cs0{:}];
            cs2 = msplitapply(@(u) calc_pwise_utility(u,H,this.motion_model), ...
                              u,findgroups(G));           
        end
        
        function [utility,cs,err] = calc_objective(this,dr,G,H)
            [cs,err] = calc_cviu16_objective(this,dr,G,H);
            utility = sum(isfinite(cs));
        end
    end
end


% function err = calc_err_cvpr14(this,dr,G,H)        
%     v = blkdiag(H,H,H)*[dr(:).u];
%     w = v([3 6 9],:);
%     v = LAF.renormI(v);
%     sc = abs(LAF.calc_scale(v));
%
%     valid = all(w > 0);
%     assert(sum(valid > 0) == sum((sc > 0) & valid), ...
%            'There are valid lafs with negative scale.'); 
%
%     logsc = nan(1,numel(sc));
%     logsc(valid) = log(sc(valid));
%
%     [err_tmp,err_idx] = ...
%         cmp_splitapply(@(x,g) deal({abs(x-median(x))},{g}), ...
%                    logsc,1:numel(dr),findgroups(G));
%
%     err_tmp = [err_tmp{:}];
%     err = inf*ones(1,numel(dr));
%     err([err_idx{:}]) = err_tmp;
% end

