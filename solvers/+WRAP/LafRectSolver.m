classdef LafRectSolver < handle & matlab.mixin.Heterogeneous
    properties
        mss = [];
    end
    
    methods
        function this = LafRectSolver(mss,cc)
            this.mss = mss;
        end
        
        function flag = is_sample_good(this,dr,corresp,idx)
            flag = numel(unique(corresp(:,idx))) == 2*this.mss;
        end    
        
        function flag = is_model_good(this,x,corresp,idx,M)      
            flag = false;

            m = corresp(:,idx);
            x = x(:,m(:));
            if ~isfield(M,'q')
                flag = LAF.are_same_orientation(x,M.l); 
            else
                nq = M.q*sum(2*M.cc)^2;
                if nq <= 0 && nq > -6
                    xp = LAF.ru_div(x,M.cc,M.q);
                    flag = LAF.are_same_orientation(xp,M.l); 
                end
            end
        end                
        
        function M = fix(this,dr,corresp,idx,M)
            M = [];
        end
    end
end
