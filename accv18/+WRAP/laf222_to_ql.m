% Copyright (c) 2017 James Pritts
% 
classdef laf222_to_ql < WRAP.RectSolver
    properties
        name = 'H222ql';
        solver = 'accv18';
    end

    methods
        function this = laf222_to_ql(varargin)
            this = this@WRAP.RectSolver('222');   
            this = cmp_argparse(this,varargin{:}); 
        end

        function [q,ll] = accv18(this,x,idx,cc,varargin)
            x = reshape(x,3,[]);
            [q,ll] = ...
                solver_changeofscale_222_new_basis_d2(x(1:2,1:3), ...
                                                      x(1:2,4:6), ...
                                                      x(1:2,7:9), ...
                                                      x(1:2,10:12), ...
                                                      x(1:2,13:15), ...
                                                      x(1:2,16:18)); 
        end
        
        function [q,ll] = accv18_grevlex(this,x,idx,cc,varargin)
            x = reshape(x,3,[]);
            [q,ll] = ...
                solver_changeofscale_222_d2(x(1:2,1:3), ...
                                            x(1:2,4:6), ...
                                            x(1:2,7:9), ...
                                            x(1:2,10:12), ...
                                            x(1:2,13:15), ...
                                            x(1:2,16:18)); 
        end        

        function [q,ll] = ijcv19(this,x,idx,cc,varargin)
            x1 = PT.calc_mu(x(:,1:2:end));
            s1 = PT.calc_scale(x(:,1:2:end));
            c1 = ones(1,numel(s1));
            x2 = PT.calc_mu(x(:,2:2:end));
            s2 = PT.calc_scale(x(:,2:2:end));
            c2 = ones(1,numel(s2));

            [q,ll] = solver_rect_cos_222_bs(x1,s1,c1,x2,s2,c2);
            ll = [ll;ones(1,size(ll,2))];
        end
        
        function [q,ll] = ijcv19_grevlex(this,x,idx,cc,varargin)
            x1 = PT.calc_mu(x(:,1:2:end));
            s1 = PT.calc_scale(x(:,1:2:end));
            c1 = ones(1,numel(s1));
            x2 = PT.calc_mu(x(:,2:2:end));
            s2 = PT.calc_scale(x(:,2:2:end));
            c2 = ones(1,numel(s2));

            [q,ll] = old_solver_rect_cos_222(x1,s1,c1,x2,s2,c2);
            ll = [ll;ones(1,size(ll,2))];
        end
               
        function M = fit(this,x,idx,cc,varargin)
            m = size(x,1);
            M = [];
            A = [1 0 -cc(1); ...
                 0 1 -cc(2); ...
                 0 0  1];    
            xn = reshape(A*reshape(x(:,[idx{:}]),3,[]),m,[]);            

            switch this.solver
              case 'accv18'
                tic
                [q,ll] = ...
                    this.accv18(xn,idx,cc,varargin{:});
                solver_time = toc;
              case 'ijcv19'
                tic
                [q,ll] = ...
                    this.ijcv19(xn,idx,cc,varargin{:});
                solver_time = toc;
                
              case 'accv18_grevlex'
                [q,ll] = ...
                    this.accv18_grevlex(xn,idx,cc,varargin{:});
                solver_time = toc;
                
              case 'ijcv19_grevlex'
                [q,ll] = ...
                    this.ijcv19_grevlex(xn,idx,cc,varargin{:});
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
