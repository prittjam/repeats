% Copyright (c) 2017 James Pritts
% 
classdef laf22_to_l < WRAP.LafRectSolver
    properties
        cc = [];
    end

    methods
        function this = laf22_to_l(cc)
            this = this@WRAP.LafRectSolver(2);
            this.cc = cc;
        end

        function M = fit(this,x,corresp,idx,varargin)
            M = [];
            A = [1 0 -this.cc(1); ...
                 0 1 -this.cc(2); ...
                 0 0  1];    
            xd = A*reshape(x(:,reshape(corresp(:,idx),1,[])),3,[]);
            tic
            [l,sols] = ...
                solver_changeofscale_22_det_norad(xd(1:2,1:3), ...
                                                  xd(1:2,4:6), ...
                                                  xd(1:2,7:9), ...
                                                  xd(1:2,10:12));
            solver_time = toc;
            N = size(l,2);
            if N > 0 
                ll2 = A'*l;
                ll2 = bsxfun(@rdivide,ll2,ll2(3,:));
                M = struct('q', 0, ...
                           'l', mat2cell(real(ll2),3,ones(1,N)), ...
                           'cc', this.cc, ...
                           'solver_time', solver_time);
                
            end
        end
    end
end
