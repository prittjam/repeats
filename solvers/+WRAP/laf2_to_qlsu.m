% Copyright (c) 2017 James Pritts
% 
classdef laf2_to_qlsu < WRAP.LafRectSolver
    properties
        solver_impl = [];
    end
    
    methods
        function this = laf2_to_qlsu(cc)
            this = this@WRAP.LafRectSolver(1);
            this.solver_impl = WRAP.pt3x2_to_qlsu(cc);
        end
        
        function [] = set_solver(this,solver)
            this.solver_impl.solver = solver;
        end

        function M = fit(this,x,corresp,idx,varargin)
            m = corresp(:,idx(1));
            x = x(:,m(:));
            xp = [x(1:3,:) x(4:6,:) x(7:9,:)];
            M = this.solver_impl.fit(xp,[1 3 5; 2 4 6],[1 2 3]);
        end
    end
end
