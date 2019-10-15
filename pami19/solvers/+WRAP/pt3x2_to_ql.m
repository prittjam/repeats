% Copyright (c) 2017 James Pritts
% 
classdef pt3x2_to_ql < handle
    properties
        solver = 'cpp';
        cspond = [];
    end

    methods(Static)
        function M = solve(x)
            M = [];

            tic
            [q,l] = evl_solver(x(1:3,:), x(4:6,:));
            solver_time = toc;
            
            q = transpose(q);
            
            if ~isempty(q)
                good_ind = abs(imag(q)) < 1e-6 & ...
                    ~isnan(q) & ...
                    isfinite(q);
                
                n = sum(good_ind);                                                  
                if n > 0 
                    M = struct('q', mat2cell(real(q(good_ind)),1,ones(1,n)), ...
                               'l', mat2cell(real(l(:,good_ind)),3,ones(1,n)), ...
                               'solver_time', solver_time);
                end
            end
        end
        
        function [q,l] = find_opt_solution(x,q,l,cspond)
            good_flag = abs(imag(q)) < 1e-6 & ...
                ~isnan(q) & ...
                isfinite(q);
            qflag = (q <= 0) & (q > -8) & good_flag;
            
            q = q(qflag);
            l = l(:,qflag);
            x = [x(1:3,:), x(4:6,:)];
            u = zeros(3,numel(cspond));

            cc = [0 0];
            d2 = zeros(1,numel(q));
            
            for k1 = 1:numel(q)
                xu = PT.ru_div(x,cc,q(k1));
                for k2 = 1:numel(cspond)
                    cs = cspond{k2};
                    u(:,k2) = WRAP.pt1x2l_to_u(reshape(xu(:,cs(:)),6,[]),l(:,k1));
                    Hu = [eye(3)+u(:,k2)*l(:,k1)'];
                    x2d = PT.rd_div(PT.renormI(Hu*PT.ru_div(x(:, ...
                                                              cs(1,:)),cc,q(k1))),cc,q(k1));
                    
                    x1d = PT.rd_div(PT.renormI(Hu \ PT.ru_div(x(:, ...
                                                              cs(2, ...
                                                                 :)),cc,q(k1))),cc,q(k1));
                    err2 = (x2d-x(:,cs(2,:))).^2+(x1d-x(:,cs(1,:))).^2;
                    d2(k1) = sum(err2(:));
                end
            end
            
            [~,idx] = min(d2);

            q = q(idx);
            l = l(:,idx);
        end
        
        function M = cpp_solve(x,cspond)
            M = [];
            res = nan(3,40);

            tic
            for k = 0:9
                res(:,4*k+1:4*(k+1)) = solver_evl_mex([x(1:2,:) x(4:5,:)],k);
            end
            solver_time = toc;
            
            is_good = ~all(res == 0);
            q = res(1,is_good);
            l = [res(2:3,is_good);ones(1,sum(is_good))];
            [optq,optl] = WRAP.pt3x2_to_ql.find_opt_solution(x,q,l,cspond);
           
            if ~isempty(optq)
                M = struct('q', optq, ...
                           'l', optl, ...
                           'solver_time', solver_time);
            end
        end
        
        function M = random_cpp_solve(x,cspond)
            M = [];
            k = randi([0 9]);
            tic
            res = solver_evl_mex([x(1:2,:) x(4:5,:)],k);
            solver_time = toc;
            
            is_good = ~all(res == 0);
            q = res(1,is_good);
            l = [res(2:3,is_good);ones(1,sum(is_good))];
            [optq,optl] = WRAP.pt3x2_to_ql.find_opt_solution(x,q,l,cspond);
            if ~isempty(optq)
                M = struct('q', optq, ...
                           'l', optl, ...
                           'solver_time', solver_time);
            end
        end
        
    end
    
    methods
        function this = pt3x2_to_ql(varargin)
            this = cmp_argparse(this,varargin{:});
            this.cspond = { [1 2 3;4 5 6], ...
                            [1 4; 4 6], ...
                            [1 4; 2 5], ...
                            [2 3; 5 6] };
        end
        
        function M = unnormalize(this,M,cc)
            A = CAM.make_fitz_normalization(cc);
            invA = inv(A); 
            normcc = sum(2*invA(1:2,3))^2;

            M.l = RP2.renormI(A'*M.l);
            M.q = M.q/normcc;
            
            M.cc = cc;
        end
        
        function M = fit(this,x,idx,cc)
            A = CAM.make_fitz_normalization(cc);
            xn = A*x(:,idx);
            
            xng = reshape(xn,6,[]);
            assert(size(xng,2)==3, ...
                   'incorrect number of correspondences');

            switch this.solver
              case 'matlab'
                M = WRAP.pt3x2_to_ql.solve(xng);
              
              case 'cpp'
                M = WRAP.pt3x2_to_ql.cpp_solve(xng,this.cspond);
                
              case 'random_cpp'
                M = WRAP.pt3x2_to_ql.random_cpp_solve(xng,this.cspond);
                
              otherwise
                throw;
            end            
            
            M = arrayfun(@(m) this.unnormalize(m,cc),M);
        end
    end
end
