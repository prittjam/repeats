% Copyright (c) 2017 James Pritts
% 
classdef laf22_to_Hinf < WRAP.LafRectSolver
    methods(Static)
        function H = solve(aX,arsc)
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
        
        function H = iter_solve(u,G)
            v = u;
            H = eye(3,3);
            for k = 1:3         
                [mu,sc] = ...
                    cmp_splitapply(@(x) ...
                                   (deal({(x(1:2,:)+x(4:5,:)+x(7:8,:))/3}, ...
                                         {1./nthroot(LAF.calc_scale(x),3)})),v,G);
                Hk = WRAP.laf22_to_Hinf.solve(mu,sc);
                H = Hk*H;
                v = LAF.renormI(blkdiag(H,H,H)*u);
            end
        end        
    end
    
    methods
        function this = laf22_to_Hinf()
            this = this@WRAP.LafRectSolver([2 2]);
        end
        
        function M = fit(this,x,corresp,idx,varargin)            
            G = varargin{1};
            m = corresp(:,idx);
            x = x(:,m(:));
            M.Hinf = WRAP.laf22_to_Hinf.iter_solve(x,G(m(:)));
            M.l = transpose(M.Hinf(3,:));
        end
    end
end 
