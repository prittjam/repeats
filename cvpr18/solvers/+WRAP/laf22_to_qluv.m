% Copyright (c) 2017 James Pritts
% 
classdef laf22_to_qluv < WRAP.RectSolver
    properties
        solver_impl = [];
    end
    
    methods
        function this = laf22_to_qluv(solver_type)
            if nargin < 1
                solver_type = 'det';
            end            
            
            this = this@WRAP.RectSolver('22');
            this.solver_impl = ...
                WRAP.pt4x2_to_qluv('solver',solver_type);
        end
        
        function M = fit(this,x,idx,cc,varargin)
            x = x(:,[idx{:}]);
            xp = [x(1:3,1:2) x(4:6,1:2) x(1:3,3:4) x(4:6,3:4)];
            M = this.solver_impl.fit(xp, ...
                                     mat2cell([1 3 5 7;2 4 6 8], ...
                                              2,ones(1,4)),cc);
        end
    end
end
