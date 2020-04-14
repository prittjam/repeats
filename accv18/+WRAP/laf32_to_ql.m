% Copyright (c) 2017 James Pritts
% 
classdef laf32_to_ql < WRAP.HybridRectSolver
    properties
        name = 'H32ql';
        solver = 'accv18';
    end

    methods
        function this = laf32_to_ql(varargin)
            this = this@WRAP.HybridRectSolver('r32');
            this = cmp_argparse(this,varargin{:});             
        end
        
        function [q,ll] = accv18(this,x,idx,cc,varargin)
            x = reshape(x,3,[]);
            [q,ll] = ...
                solver_changeofscale_32_new_basis_d2(x(1:2,1:3), ...
                                                     x(1:2,4:6), ...
                                                     x(1:2,7:9), ...
                                                     x(1:2,10:12), ...
                                                     x(1:2,13:15)); 
        end
        
        function [q,ll] = accv18_grevlex(this,x,idx,cc,varargin)
            x = reshape(x,3,[]);
            [q,ll] = ...
                solver_changeofscale_32_d2(x(1:2,1:3), ...
                                           x(1:2,4:6), ...
                                           x(1:2,7:9), ...
                                           x(1:2,10:12), ...
                                           x(1:2,13:15)); 
        end
        
        function [q,ll] = ijcv19(this,x,idx,cc,varargin)
            mux = PT.calc_mu(x);
            sc = PT.calc_scale(x);
            c = ones(1,size(mux,2));
            [q,ll] = solver_rect_cos_32_bs(mux(:,idx{1}),sc(idx{1}),c(idx{1}), ...
                                           mux(:,idx{2}),sc(idx{2}),c(idx{2}));
            ll = [ll;ones(1,size(ll,2))];
        end
        
        function [q,ll] = ijcv19_grevlex(this,x,idx,cc,varargin)
            mux = PT.calc_mu(x);
            sc = PT.calc_scale(x);
            c = ones(1,size(mux,2));
            [q,ll] = solver_rect_cos_32_baseline(mux(:,idx{1}),sc(idx{1}),c(idx{1}), ...
                                                 mux(:,idx{2}),sc(idx{2}),c(idx{2}));
            ll = [ll;ones(1,size(ll,2))];
        end

        function M = fit(this,x,idx,cc,varargin)
            x = x{1};
            idx = idx{1};
            M = [];
            A = [1 0 -cc(1); ...
                 0 1 -cc(2); ...
                 0 0  1];    
            
            switch this.solver
              case 'accv18'
                xd = A*reshape(x(:,[idx{:}]),3,[]);
                tic
                [q,ll] = ...
                    this.accv18(xd,idx,cc,varargin{:});
                solver_time = toc;
              case 'ijcv19'
                xd = blkdiag(A,A,A)*x;
                tic
                [q,ll] = ...
                    this.ijcv19(xd,idx,cc,varargin{:});
                solver_time = toc;
                
              case 'accv18_grevlex'
                xd = A*reshape(x(:,[idx{:}]),3,[]);
                [q,ll] = ...
                    this.accv18_grevlex(xd,idx,cc,varargin{:});
                solver_time = toc;
                
              case 'ijcv19_grevlex'
                xd = blkdiag(A,A,A)*x;
                [q,ll] = ...
                    this.ijcv19_grevlex(xd,idx,cc,varargin{:});
                solver_time = toc;
                
              otherwise
                throw;
            end            

            ll2 = A'*ll;
            ll2 = bsxfun(@rdivide,ll2,ll2(3,:));
            N = numel(q);
            M = struct('q', mat2cell(q,1,ones(1,N)), ...
                       'l', mat2cell(ll2,3,ones(1,N)), ...
                       'cc', cc, ...
                       'solver_time', solver_time);            
        end
    end
end
