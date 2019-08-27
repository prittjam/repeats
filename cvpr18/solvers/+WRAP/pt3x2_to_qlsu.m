% Copyright (c) 2017 James Pritts
% 
classdef pt3x2_to_qlsu < handle
    properties
        solver = 'det';
    end
    
    methods(Static)
        function M = solve(u,solver)
            if nargin < 2
                solver = 'det';
            end
            
            x11 = u(4:6,1);
            x1p1 = u(1:3,1);
    
            x21 = u(4:6,2);
            x2p1 = u(1:3,2);

            x31 = u(4:6,3);
            x3p1 = u(1:3,3);

            M = [];

            switch solver
              case 'gb'
                tic;
                [s, v1, v2, v3, l1, l2, k] = ...
                    solver_H3lvks_74x76(x11, x1p1, x21, x2p1, x31, ...
                                        x3p1);
                solver_time = toc;
              case 'det'
                tic;
                [s, v1, v2, v3, l1, l2, k]  = ...
                    solver_H3lvks_det_24x26(x11,x1p1,x21,x2p1,x31, ...
                                            x3p1);
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
                               's', mat2cell(real(s(good_ind)),1,ones(1,n)), ...
                               'Hu', [],'Hsu',[], ...
                               'solver_time', solver_time);                
                end
            end
        end
    end
    
    methods
        function this = pt3x2_to_qlsu()
        end
        
        function M = unnormalize(this,M,cc)
            A = CAM.make_fitz_normalization(cc);
            invA = inv(A); 
            normcc = sum(2*invA(1:2,3))^2; 
            
            M.Hu = invA*(eye(3)+M.u*M.l')*A;
            M.Hsu = invA*(eye(3)+M.s*M.u*M.l')*A;
            M.l = M.l/norm(M.l);
            M.l = A'*M.l;
            M.u = invA*M.u;            
            M.q = M.q/normcc;
            M.cc = cc;

            M.Hinf = eye(3,3);
            M.Hinf(3,:) = transpose(M.l);
        end
        
        function M = fit(this,x,idx,cc)
            A = CAM.make_fitz_normalization(cc);
            un = A*x(:,idx);
            ung = reshape(un,6,[]);
            assert(size(ung,2)==3, ...
                   'incorrect number of correspondences');
            M = WRAP.pt3x2_to_qlsu.solve(ung,this.solver);
            M = arrayfun(@(m) this.unnormalize(m,cc),M);
        end
    end
end
