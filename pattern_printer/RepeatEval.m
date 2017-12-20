classdef RepeatEval < handle
    properties    
        extentT = log(1.05);
    end
    
    methods
        function this = RepeatEval(varargin)
            [this,~] = cmp_argparse(this,varargin{:});
        end        
        
        function [loss,E] = calc_loss(this,x,corresp,M)         
            H = M.Hinf;
            if ~isfield(M,'q')
                xp = LAF.renormI(blkdiag(H,H,H)*x);                
            else
                xp = LAF.renormI(blkdiag(H,H,H)*LAF.ru_div(x,M.cc,M.q));                
            end
            
            D2 = [sum((xp(1:2,:)-xp(4:5,:)).^2); ...
                  sum((xp(7:8,:)-xp(4:5,:)).^2); ...
                  sum((xp(7:8,:)-xp(1:2,:)).^2)];
            lr = 0.5*(log(D2(:,corresp(2,:)))-log(D2(:,corresp(1,:))));

            E = max(abs(lr)); 

            E(isnan(E)) = this.extentT;
            E(E > this.extentT) = this.extentT;
            loss = sum(E);
        end        
        
        function cs = calc_cs(this,E)
            cs = E < this.extentT;
        end                        
    end
end
