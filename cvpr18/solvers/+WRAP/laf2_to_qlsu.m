% Copyright (c) 2017 James Pritts
% 
classdef laf2_to_qlsu < WRAP.HybridRectSolver
    properties
        solver_impl = [];
    end
    
    methods
        function this = laf2_to_qlsu(solver_type)
            if nargin < 1
                solver_type = 'det';
            end
            
            this = this@WRAP.HybridRectSolver('r2');
            this.solver_impl = WRAP.pt3x2_to_qlsu('solver',solver_type);
        end
        
        function M = fit(this,x,idx,cc,varargin)
            x = x{1};
            idx = idx{1};
            x = x(:,[idx{:}]);
            xp = [x(1:3,:) x(4:6,:) x(7:9,:)];
            M = this.solver_impl.fit(xp,[1 3 5; 2 4 6],cc);
        end
    end
end
