% Copyright (c) 2017 James Pritts
% 
classdef laf22_to_l < WRAP.HybridRectSolver
    properties
        q = [];
        solver_type = 'polynomial';
    end

    methods
        function this = laf22_to_l(varargin)
            this = this@WRAP.HybridRectSolver('r22');
            this = cmp_argparse(this,varargin{:});
        end

        function M = fit(this,x,idx,cc,varargin)
            switch(this.solver_type)
              case 'polynomial'
                M = [];
                A = [1 0 -cc(1); ...
                     0 1 -cc(2); ...
                     0 0  1];    
                xd = A*reshape(x(:,[idx{:}]),3,[]);
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
                    M = struct('l', mat2cell(ll2,3,ones(1,N)), ...
                               'q',0, ...
                               'solver_time', solver_time);
                end
                
              case 'linear'
                G = varargin{1};
                l = laf22_to_l(x(:,[idx{:}]),findgroups(G([idx{:}])))
                M = struct('l', l, ...
                           'q', 0, ...
                           'solver_time', solver_time);
            end
        end
    end
end
