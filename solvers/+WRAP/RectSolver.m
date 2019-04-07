%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef RectSolver < handle & matlab.mixin.Heterogeneous
    properties
        mss = [];
        sample_type = [];
    end
    
    methods
        function this = RectSolver(sample_type)
            switch sample_type
              case '2'
                this.mss = 2;
                
              case '22'
                this.mss = [2 2];
                
              case '22s'
                this.mss = [2 2];

              case '222'
                this.mss = [2 2 2];
                                
              case '32'
                this.mss = [3 2];
                
              case '4'
                this.mss = 4;
                
              otherwise
                throw('Incorrect sample type for rectifying solvers');
            end
            
            this.sample_type = sample_type;
        end
        
        function flag = is_sample_good(this,x,idx)
            flag = numel(unique([idx{:}])) == sum(this.mss);
        end    
        
        function flag = is_model_good(this,x,idx,M)      
            flag = false;
            m = [idx{:}];
            x = x(:,m(:));
            if ~isfield(M,'q')
                flag = PT.are_same_orientation(x,M.l) & isreal(M.l); 
            else
                nq = M.q*sum(2*M.cc)^2;
                if nq <= 0 && nq > -8
                    xp = PT.ru_div(x,M.cc,M.q);
                    flag = PT.are_same_orientation(xp,M.l) & isreal(M.l); 
                end
            end
        end                

        function M = fix(this,x,idx,M)
            M = [];
        end
    end
end