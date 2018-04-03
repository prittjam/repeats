% Copyright (c) 2017 James Pritts
% 
classdef laf32_to_ql < WRAP.LafRectSolver
    properties
        cc = [];
    end

    methods
        function this = laf32_to_ql(cc)
            this = this@WRAP.LafRectSolver([3 2]);
            this.cc = cc;
        end

        function M = fit(this,x,corresp,idx,varargin)
            M = [];
            A = [1 0 -this.cc(1); ...
                 0 1 -this.cc(2); ...
                 0 0  1];    
            xd = A*reshape(x(:,unique(reshape(corresp(:,idx),1,[]))),3,[]);
            tic
            [q,ll] = ...
                solver_changeofscale_32_new_basis_d2(xd(1:2,1:3), ...
                                                     xd(1:2,4:6), ...
                                                     xd(1:2,7:9), ...
                                                     xd(1:2,10:12), ...
                                                     xd(1:2,13:15)); 
            solver_time = toc;
            qn = q*sum(2*this.cc)^2;
            good_ind = find((qn < 1) & (qn > -8));
            N = numel(good_ind);
            if N > 0 
                ll2 = A'*ll;
                ll2 = bsxfun(@rdivide,ll2,ll2(3,:));
                M = struct('q', mat2cell(real(q(good_ind)),1,ones(1,N)), ...
                           'l', mat2cell(real(ll2(:,good_ind)),3,ones(1,N)), ...
                           'cc', this.cc, ...
                           'solver_time', solver_time);
                
            end
        end
    end
end
