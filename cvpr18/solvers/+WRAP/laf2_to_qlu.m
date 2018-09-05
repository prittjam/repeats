% Copyright (c) 2017 James Pritts
% 
classdef laf2_to_qlu < WRAP.LafRectSolver
    properties
        solver_impl = [];
        name = 'H2.5qlu';
    end
    
    methods (Static)
        function obj = getObj(cc) 
            obj = WRAP.laf2_to_qlu(cc)
        end
    end         
        
    methods
        function this = laf2_to_qlu(cc)
            this = this@WRAP.LafRectSolver('laf2'); 
            this.solver_impl = WRAP.pt3x2_to_qlu(cc);      
        end
        
        function [] = set_solver(this,solver)
            this.solver_impl.solver = solver;
        end
        
        function M = fit(this,x,corresp,idx,varargin)
            x = x(:,[idx{:}]);
            xp = [x(1:3,1:2) x(4:6,1:2) x(7:9,1:2)];
            M = this.solver_impl.fit(xp,[1 3 5; 2 4 6],[1 2 3]);
        end
    end
end
