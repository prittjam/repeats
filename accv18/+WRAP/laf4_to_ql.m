% Copyright (c) 2017 James Pritts
% 
classdef laf4_to_ql < WRAP.RectSolver
    properties
        name = 'H4ql';
        solver = 'accv18';
    end

    methods
        function this = laf4_to_ql(varargin)
            this = this@WRAP.RectSolver('4');
            this = cmp_argparse(this,varargin{:});                         
        end
        
        
        function [q,ll] = accv18_fit(this,x,idx,cc,varargin)
            x = reshape(x,3,[]);
            [q,ll] = ...
                solver_changeofscale_4_new_basis_d2(x(1:2,1:3), ...
                                                    x(1:2,4:6), ...
                                                    x(1:2,7:9), ...
                                                    x(1:2,10:12)); 
        end
        
        function [q,ll] = ijcv19_fit(this,x,idx,cc,varargin)
            x1 = PT.calc_mu(x(:,1:2:end));
            s1 = PT.calc_scale(x(:,1:2:end));
            c1 = ones(1,numel(s1));
            x2 = PT.calc_mu(x(:,2:2:end));
            s2 = PT.calc_scale(x(:,2:2:end));
            c2 = ones(1,numel(s2));

            [q,ll] = solver_rect_cos_222(x1,s1,c1,x2,s2,c2);
            ll = [ll;ones(1,size(ll,2))];
        end        

        function M = fit(this,x,idx,cc,varargin)
            M = [];
            A = [1 0 -cc(1); ...
                 0 1 -cc(2); ...
                 0 0  1];    
            xd = A*reshape(x(:,[idx{:}]),3,[]);
            
            if strcmpi(this.solver,'accv18')
                tic
                [q,ll] = this.accv18_fit(xd,idx,cc,varargin{:});
                solver_time = toc;
            else
                tic
                [q,ll] = this.ijcv19_fit(xd,idx,cc,varargin{:});
                solver_time = toc;
            end 
             
            ll2 = A'*ll;
            ll2 = bsxfun(@rdivide,ll2,ll2(3,:));
            M = struct('q', mat2cell(q,1,ones(1,N)), ...
                       'l', mat2cell(ll2,3,ones(1,N)), ...
                       'cc', cc, ...
                       'solver_time', solver_time);
        end
    end
end
