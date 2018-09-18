% Copyright (c) 2017 James Pritts
% 
classdef laf2_to_qlsu < WRAP.LafRectSolver
    properties
        solver_impl = [];
        name =  'H3qlsu';
    end
    
    methods
        function this = laf2_to_qlsu(cc)
            this = this@WRAP.LafRectSolver('laf2');
            this.solver_impl = WRAP.pt3x2_to_qlsu();
        end
        
        function [] = set_solver(this,solver)
            this.solver_impl.solver = solver;
        end

        function M = fit(this,x,corresp,idx,cc,varargin)
            x = x(:,[idx{:}]);
            xp = [x(1:3,:) x(4:6,:) x(7:9,:)];
            M = this.solver_impl.fit(xp,[1 3 5; 2 4 6],[1 2 3],cc);
        end
    end
end
