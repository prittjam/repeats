% Copyright (c) 2017 James Pritts
% 
classdef laf22_to_l < WRAP.RectSolver
    properties
        q = [];
        solver_type = 'polynomial';
    end

    methods(Static)
        function H = solve_accv10(aX,arsc)
            if ~iscell(aX)
                aX = {aX};
                arsc = {arsc};
            end

            ALLX = [aX{:}];
            ALLX = ALLX(1:2,:);

            tx = mean(ALLX(1,:));
            ty = mean(ALLX(2,:));
            ALLX(1,:) = ALLX(1,:) - tx;
            ALLX(2,:) = ALLX(2,:) - ty;
            dsc = max(abs(ALLX(:)));

            A = eye(3);
            A([1,2],3) = -[tx ty] / dsc;
            A(1,1) = 1 / dsc;
            A(2,2) = 1 / dsc;

            len = length(aX);
            Z = [];
            R = [];

            for i = 1:len
                X = aX{i};
                rsc = arsc{i};
                X(1,:) = (X(1,:) - tx) / dsc;
                X(2,:) = (X(2,:) - ty) / dsc;
                
                z = [rsc .* X(1,:); rsc .* X(2,:)];
                z(len+2, :) = 0;
                z(i+2,:) = -ones(1, size(X,2));
                
                Z = [Z; z'];
                R = [R; rsc(:)];
            end

            hs = pinv(Z) * -R;

            H = eye(3);

            H(3,1) = hs(1);
            H(3,2) = hs(2);
            H = H * A;
        end
        
        function [H,solver_time] = iter_solve_accv10(u,G)
            v = u;
            H = eye(3,3);
            solver_time = 0;
            for k = 1:1         
                [mu,sc] = ...
                    cmp_splitapply(@(x) ...
                                   (deal({(x(1:2,:)+x(4:5,:)+x(7:8,:))/3}, ...
                                         {1./ ...
                                    nthroot(PT.calc_scale(x),3)})),v,G);
                tic;
                Hk = WRAP.laf22_to_l.solve_accv10(mu,sc);
                tmp_solver_time = toc;
                H = Hk*H;
                v = PT.renormI(blkdiag(H,H,H)*u);
                solver_time = solver_time+tmp_solver_time;
            end
        end        
    end
    
    methods
        function this = laf22_to_l(varargin)
            this = this@WRAP.RectSolver('22');
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
                    M = struct('l', mat2cell(real(ll2),3,ones(1,N)), ...
                               'solver_time', solver_time);
                end
                
              case 'linear'
                G = varargin{1};
                [Hinf,solver_time] = ...
                    this.iter_solve_accv10(x(:,[idx{:}]),findgroups(G([idx{:}])));
                M = struct('l', transpose(Hinf(3,:)), ...
                           'solver_time', solver_time);
            end
        end
    end
end
