% Copyright (c) 2017 James Pritts
% 
classdef pt3x2_to_ql < handle
    properties
    end

    methods(Static)
        function M = solve(x)
            M = [];
            
            tic
            [q,l] = jmm_solver(x(1:3,:), x(4:6,:));
            solver_time = toc;
            
            q = transpose(q);
            
            if ~isempty(q)
                good_ind = abs(imag(q)) < 1e-6 & ...
                    ~isnan(q) & ...
                    isfinite(q);
                
                n = sum(good_ind);                                                  
                if n > 0 
                    u = nan(3,4);
                    M = struct('q', mat2cell(real(q(good_ind)),1,ones(1,n)), ...
                               'l', mat2cell(real(l(:,good_ind)),3,ones(1,n)), ...
                               'solver_time', solver_time);
                end
            end
        end
    end
    
    methods
        function this = pt3x2_to_ql()
        end
        
        function M = unnormalize(this,M,cc)
            A = CAM.make_fitz_normalization(cc);
            invA = inv(A); 
            normcc = sum(2*invA(1:2,3))^2;

            M.l = M.l/norm(M.l);
            M.l = A'*M.l;
            M.q = M.q/normcc;
            
            M.cc = cc;
        end
        
        function M = fit(this,x,idx,cc)
            A = CAM.make_fitz_normalization(cc);
            xn = A*x(:,idx);
            
            xng = reshape(xn,6,[]);
            assert(size(xng,2)==3, ...
                   'incorrect number of correspondences');

            M = WRAP.pt3x2_to_ql.solve(xng);
            M = arrayfun(@(m) this.unnormalize(m,cc),M);
        end
    end
end
