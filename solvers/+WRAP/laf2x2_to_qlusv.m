% Copyright (c) 2017 James Pritts
% 
classdef laf2x2_to_qlusv < WRAP.LafRectSolver
    properties
        solver_impl = [];
    end
    
    methods
        function this = laf2x2_to_qlusv(cc)
            this = this@WRAP.LafRectSolver(2,cc);
            this.solver_impl = WRAP.pt4x2_to_qlusv(cc);
        end
        
        function [] = set_solver(this,solver)
            this.solver_impl.solver = solver;
        end        

        function M = fit(this,x,corresp,idx,varargin)
            m = corresp(:,idx);
            x = x(:,m(:));
            xp = [x(1:3,1:2) x(4:6,1:2) x(1:3,3:4) x(4:6,3:4)];
            M = this.solver_impl.fit(xp,[1 3 5 7;2 4 6 8],[1 2 3 4]);
        end
    end
end
