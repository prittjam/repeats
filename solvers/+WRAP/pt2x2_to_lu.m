% Copyright (c) 2017 James Pritts
% 
classdef pt2x2_to_lu < Solver
    properties
        A = [];
        invA = [];
        normcc;
        cc = [];
    end

    methods(Static)
        function M = solve(x)
            l1 = cross(x(1:3,1),x(4:6,1));
            l2 = cross(x(1:3,2),x(4:6,2));
            l3 = cross(x(1:3,1),x(1:3,2));
            l4 = cross(x(4:6,1),x(4:6,2));
            
            u = cross(l1,l2);
            w = cross(l3,l4);
            l = cross(u,w);
            l = l/norm(l);

            H = u*transpose(l);
            x1 = PT.renormI(H*x(1:3,1));
            x2 = PT.renormI(H*x(4:6,1));
            s = (x(4,:)-x(1,:)) ./ ...
                ((u(1)-x(4,:).*u(3)).*(transpose(l)*x(1:3,:)));
            u = mean(s)*u;
          
            M = struct('l',l, ...
                       'u',u, ...
                       'Hu',eye(3)+u*l');
        end
    end
        
    methods
        function this = pt2x2_to_lu(cc)
            this.A = CAM.make_fitz_normalization(cc);
            this.invA = inv(this.A); 
            this.normcc = sum(2*this.invA(1:2,3))^2;
            this.cc = cc;
        end
        
        function M = unnormalize(this,M,xn)
            M.l = this.A'*M.l;
            M.u = this.invA*M.u;            
            M.Hu = this.invA*M.Hu*this.A;
            
            M.Hinf = eye(3,3);
            M.Hinf(3,:) = transpose(M.l);
        end
        
        function M = fit(this,x,corresp,idx,varargin)
            m  = corresp(:,idx);
            xn = this.A*x(:,m(:));
            xng = reshape(xn,6,[]);
            M = WRAP.pt2x2_to_lu.solve(xng);
            M = this.unnormalize(M);
        end

    end
end
