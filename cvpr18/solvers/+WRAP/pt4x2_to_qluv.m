% Copyright (c) 2017 James Pritts
% 
classdef pt4x2_to_qluv < handle
    properties
        A = [];
        invA = [];
        normcc;
        cc = [];
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

            x41 = u(4:6,4);
            x4p1 = u(1:3,4);
            
            M = [];

            switch solver
              case 'gb'
                tic;
                [u1, u2, u3, l1, l2, k, v1, v2, v3] = ...
                    solver_H4lv1v2k_35pt_348x354(x11, x1p1, x21, x2p1, ...
                                                 x31, x3p1, x41, ...
                                                 x4p1);
                solver_time = toc;
                l1 = reshape(l1,1,[]);
                u1 = reshape(u1,1,[]);
                u2 = reshape(u2,1,[]);
                u3 = reshape(u3,1,[]);
                
              case 'det'
                tic;
                [l1, l2, k, v1, v2, v3, u1, u2, u3] = ...
                    solver_H35lv1v2k_det_54x60(x11, x1p1, x21, x2p1, ...
                                               x31, x3p1,x41,x4p1);
                solver_time = toc;
            end 

            %%%% note the swap of u anv v
            if ~isempty(k)
                good_ind = abs(imag(k)) < 1e-6 & ...
                    ~isnan(k) & ...
                    isfinite(k) & ...
                    k ~= 10000;

                n = sum(good_ind);
                
                if n > 0
                    l = [l1;l2;ones(1,numel(l1))];
                    u = [u1;u2;u3];
                    v = [v1;v2;v3];
                
                    if n > 0
                        M = struct('q', mat2cell(real(k(good_ind)),1,ones(1,n)), ...
                                   'l', mat2cell(real(l(:,good_ind)),3,ones(1,n)), ...
                                   'v', mat2cell(real(u(:,good_ind)),3,ones(1,n)), ...
                                   'u', mat2cell(real(v(:,good_ind)),3,ones(1,n)), ...
                                   'Hu', [],'Hv',[], ...
                                   'solver_time', solver_time);
                    end
                end
            end
        end
    end
    
    
    methods
        function this = pt4x2_to_qluv(varargin)
            this = cmp_argparse(this,varargin{:});
        end
        
        function M = unnormalize(this,M)
            M.Hu = eye(3)+M.u*M.l';
            M.Hu = this.invA*M.Hu*this.A;
            M.Hv = eye(3)+M.v*M.l';
            M.Hv = this.invA*M.Hv*this.A;
            M.l = M.l/norm(M.l);
            M.l = this.A'*M.l;
            M.u = this.invA*M.u;            
            M.v = this.invA*M.v;            
            M.q = M.q/this.normcc;
            M.cc = this.cc;
            
            M.Hinf = eye(3);
            M.Hinf(3,:) = transpose(M.l);
        end
        
        function M = fit(this,x,idx,cc,varargin)
            this.A = CAM.make_fitz_normalization(cc);
            this.invA = inv(this.A); 
            this.normcc = sum(2*this.invA(1:2,3))^2;
            
            m = reshape([idx{:}],1,[]);
            un = this.A*x(:,m(:));
            ung = reshape(un,6,[]);
            assert(size(ung,2)==4, ...
                   'incorrect number of correspondences');
            M = WRAP.pt4x2_to_qluv.solve(ung,this.solver);            
            M = arrayfun(@(m) this.unnormalize(m),M);
        end
    end
end 
