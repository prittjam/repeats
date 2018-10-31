% Copyright (c) 2017 James Pritts
% 
classdef laf222_to_ql < WRAP.LafRectSolver
    properties
        name = 'H222ql';
        solver = 'accv18';
    end

    methods
        function this = laf222_to_ql(varargin)
            this = this@WRAP.LafRectSolver('laf222');   
            this = cmp_argparse(this,varargin{:}); 
        end

        function [q,ll] = accv18_fit(this,x,corresp,idx,cc,varargin)
            [q,ll] = ...
                solver_changeofscale_222_new_basis_d2(x(1:2,1:3), ...
                                                      x(1:2,4:6), ...
                                                      x(1:2,7:9), ...
                                                      x(1:2,10:12), ...
                                                      x(1:2,13:15), ...
                                                      x(1:2,16:18)); 
        end

        function [q,ll] = cvpr19_fit(this,x,corresp,idx,cc,varargin)
            x1 = LAF.calc_mu(x(:,1:2:end));
            s1 = PT.calc_scale(x(:,1:2:end));
            c1 = ones(1,numel(s1));
            x2 = LAF.calc_mu(x(:,2:2:end));
            s2 = PT.calc_scale(x(:,2:2:end));
            c2 = ones(1,numel(s2));

            [q,ll] = solver_rect_cos_222(x1,s1,c1,x2,s2,c2);
            ll = [ll;ones(1,size(ll,2))];
        end
               
        function M = fit(this,x,corresp,idx,cc,varargin)
            m = size(x,1);
            M = [];
            A = [1 0 -cc(1); ...
                 0 1 -cc(2); ...
                 0 0  1];    
            xn = reshape(A*reshape(x(:,[idx{:}]),3,[]),m,[]);            

            if strcmpi(this.solver,'accv18')
                tic
                [q,ll] = this.accv18_fit(xn,corresp,idx,cc, ...
                                         varargin{:});
                solver_time = toc;
            else
                tic
                [q,ll] = this.cvpr19_fit(xn,corresp,idx,cc,varargin{:});
                solver_time = toc;
            end
            
            qn = q*sum(2*cc)^2;
            good_ind = find((qn < 1) & (qn > -15));
            N = numel(good_ind);
            if N > 0 
                ll2 = A'*ll;
                ll2 = bsxfun(@rdivide,ll2,ll2(3,:));
                M = struct('q', mat2cell(real(q(good_ind)),1,ones(1,N)), ...
                           'l', mat2cell(real(ll2(:,good_ind)),3,ones(1,N)), ...
                           'cc', cc, ...
                           'solver_time', solver_time);
                
            end
        end
    end
end
