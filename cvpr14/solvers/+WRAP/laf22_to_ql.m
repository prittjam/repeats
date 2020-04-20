% Copyright (c) 2017 James Pritts
% 
classdef laf22_to_ql < WRAP.HybridRectSolver
    properties
        q = [];
        solver_type = 'polynomial';
        qvals = [0:-0.1:-6];
    end
    
    methods
        function this = laf22_to_ql(varargin)
            this = this@WRAP.HybridRectSolver('r22');
            this = cmp_argparse(this,varargin{:});
        end

        function M = fit(this,x,idx,cc,varargin)
            x = x('rgn');
            idx = idx('rgn');
            qn = this.qvals(randi(numel(this.qvals)));
            q = qn/sum(2*cc)^2;
            xu = PT.ru_div(x,cc,q);
            switch(this.solver_type)
              case 'polynomial'
                M = [];
                A = [1 0 -cc(1); ...
                     0 1 -cc(2); ...
                     0 0  1];    
                x2 = A*reshape(xu(:,[idx{:}]),3,[]);
                tic
                [l,sols] = ...
                    solver_changeofscale_22_det_norad(x2(1:2,1:3), ...
                                                      x2(1:2,4:6), ...
                                                      x2(1:2,7:9), ...
                                                      x2(1:2,10:12));
                solver_time = toc;
                N = size(l,2);
                if N > 0 
                    ll2 = A'*l;
                    ll2 = bsxfun(@rdivide,ll2,ll2(3,:));
                    q = repmat(q,1,N);
                    M = struct('l', mat2cell(real(ll2),3,ones(1,N)), ...
                               'q', mat2cell(q,1,ones(1,N)), ...
                               'solver_time', solver_time);
                end
                
              case 'linear'
                G = varargin{1};
                l = laf22_to_l(x(:,[idx{:}]),findgroups(G([idx{:}])));
                M = struct('l', l, ...
                           'q', 0, ...
                           'solver_time', solver_time);
            end
        end
    end
end
