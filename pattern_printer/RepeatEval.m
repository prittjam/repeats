classdef RepeatEval < handle
    properties    
        extentT = log(1.1);
    end
    
    methods
        function this = RepeatEval(varargin)
            [this,~] = cmp_argparse(this,varargin{:});
        end        
        
        function [loss,E] = calc_loss(this,x,cspond,M)         
            H = M.A*[1 0 0;  ...
                     0 1 0; ...
                     transpose(M.l)];
            if ~isfield(M,'q')
                q = 0;
            end
            
            xu = LAF.ru_div(x,M.cc,M.q);
            xp = LAF.renormI(blkdiag(H,H,H)*xu);
            D2 = [sum((xp(1:2,:)-xp(4:5,:)).^2); ...
                  sum((xp(7:8,:)-xp(4:5,:)).^2); ...
                  sum((xp(7:8,:)-xp(1:2,:)).^2)];
            lr = 0.5*(log(D2(:,cspond(2,:)))-...
                      log(D2(:,cspond(1,:))));
            E = max(abs(lr)); 

            E(isnan(E)) = this.extentT;
            E(E > this.extentT) = this.extentT;

            [~,side] = LAF.are_same_orientation(xu,M.l); 
            cspond_side = double(side(cspond));
            is_good = ~diff(cspond_side);
            cspond_side = cspond_side(1,:);
            cspond_side(~is_good) = nan;
            cspond_side(E == this.extentT) = nan;
            freq = hist(cspond_side,[0 1]);
            [~,ind] = min(freq);
            is_bad = find(cspond_side == ind-1); 
            E(is_bad) = this.extentT;
            
            loss = sum(E);
        end        
        
        function cs = calc_cs(this,E)
            cs = E < this.extentT;
        end                        
    end
end
