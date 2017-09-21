classdef GrEval < handle
    properties    
        T = log(1.1);
    end
    
    methods
        function this = GrEval2(varargin)
            this = cmp_argparse(this,varargin{:});
        end        
        
        function [loss,E] = calc_loss(this,dr,corresp,M)         
            H = M.H;
            v = LAF.renormI(blkdiag(H,H,H)*[dr(:).u]);
            
            D2 = [sum((v(1:2,:)-v(4:5,:)).^2); ...
                  sum((v(7:8,:)-v(4:5,:)).^2); ...
                  sum((v(7:8,:)-v(1:2,:)).^2)];
            lr = 0.5*(log(D2(:,corresp(2,:)))-log(D2(:,corresp(1,:))));

            E = max(abs(lr)); 

            E(isnan(E)) = this.T;
            E(E > this.T) = this.T;
            loss = sum(E);
        end        
        
        function cs = calc_cs(this,E)
            cs = E < this.T;
        end                        
    end
end
