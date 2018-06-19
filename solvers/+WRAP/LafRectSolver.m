classdef LafRectSolver < handle & matlab.mixin.Heterogeneous
    properties
        mss = [];
        sample_type = [];
    end
    
    methods
        function this = LafRectSolver(sample_type)
            switch sample_type
              case 'laf2'
                this.mss = 2;
                
              case 'laf22'
                this.mss = [2 2];
                
              case 'laf22s'
                this.mss = [2 2];

              case 'laf222'
                this.mss = [2 2 2];
                                
              case 'laf32'
                this.mss = [3 2];
                
              case 'laf4'
                this.mss = 4;
                
              otherwise
                throw('Incorrect sample type for rectifying solvers');
            end
            
            this.sample_type = sample_type;
        end
        
        function flag = is_sample_good(this,x,corresp,idx)
            flag = numel(unique([idx{:}])) == sum(this.mss);
        end    
        
        function flag = is_model_good(this,x,corresp,idx,M)      
            flag = false;
            m = [idx{:}];
            x = x(:,m(:));
            if ~isfield(M,'q')
                flag = LAF.are_same_orientation(x,M.l); 
            else
                nq = M.q*sum(2*M.cc)^2;
                if nq <= 0 && nq > -8
                    xp = LAF.ru_div(x,M.cc,M.q);
                    flag = LAF.are_same_orientation(xp,M.l); 
                end
            end
        end                
        
        function M = fix(this,x,corresp,idx,M)
            M = [];
        end
    end
end
