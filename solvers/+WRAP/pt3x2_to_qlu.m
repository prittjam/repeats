% Copyright (c) 2017 James Pritts
% 
classdef pt3x2_to_qlu < Solver
    properties
        A = [];
        invA = [];
        normcc;
        cc = [];
        
        solver = 'det';
    end

    methods(Static)
        function M = solve(x,solver)
            if nargin < 2
                solver = 'det';
            end
            
            x11 = x(4:6,1);
            x1p1 = x(1:3,1);
            
            x21 = x(4:6,2);
            x2p1 = x(1:3,2);

            x31 = x(4:6,3);
            x3p1 = x(1:3,3);

            M = [];

            switch solver
              case 'gb'
                tic;
                [v1, v2, v3, l1, l2, k] = ...
                    solver_H25lvk(x11, x1p1, x21, x2p1, x31, x3p1);                
                solver_time = toc;
              case 'det'
                tic;
                [v1, v2, v3, l1, l2, k] = ...
                    solver_H25lvk_det_14x18(x11, x1p1, x21, x2p1, ...
                                            x31, x3p1);
                solver_time = toc;
            end 
            
            if ~isempty(k)
                good_ind = abs(imag(k)) < 1e-6 & ...
                    ~isnan(k) & ...
                    isfinite(k) & ...
                    k ~= 10000;
                
                n = sum(good_ind);                                   
                
                if n > 0 
                    l = [l1;l2;ones(1,numel(l1))];
                    v = [v1;v2;v3];
                    M = struct('q', mat2cell(real(k(good_ind)),1,ones(1,n)), ...
                               'l', mat2cell(real(l(:,good_ind)),3,ones(1,n)), ...
                               'u', mat2cell(real(v(:,good_ind)),3,ones(1,n)), ...
                               'Hu', [], ...
                               'solver_time', solver_time);
                end
            end
        end
    end
    
    methods
        function this = pt3x2_to_qlu(cc)
            this.A = CAM.make_fitz_normalization(cc);
            this.invA = inv(this.A); 
            this.normcc = sum(2*this.invA(1:2,3))^2;
            this.cc = cc;
        end
        
        function M = unnormalize(this,M)
            M.Hu = eye(3)+M.u*M.l';
            M.Hu = this.invA*M.Hu*this.A;
            M.l = M.l/norm(M.l);
            M.l = this.A'*M.l;
            M.u = this.invA*M.u;            
            M.q = M.q/this.normcc;
            M.cc = this.cc;
            M.Hinf = eye(3);
            M.Hinf(3,:) = transpose(M.l);
        end
        
        function M = fit(this,x,corresp,idx)
            m  = corresp(:,idx);
            xn = this.A*x(:,m(:));
            xng = reshape(xn,6,[]);
            assert(size(xng,2)==3, ...
                   'incorrect number of correspondences');
            M = WRAP.pt3x2_to_qlu.solve(xng,this.solver);
            M = arrayfun(@(m) this.unnormalize(m),M);
        end

    end
end
