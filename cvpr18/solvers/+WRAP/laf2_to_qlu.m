% Copyright (c) 2017 James Pritts
% 
classdef laf2_to_qlu < WRAP.RectSolver
    properties
        solver_impl = [];
        name = 'H2.5qlu';
    end
    
    methods (Static)
        function obj = getObj() 
            obj = WRAP.laf2_to_qlu();
        end
    end         
        
    methods
        function this = laf2_to_qlu()
            this = this@WRAP.RectSolver('2'); 
            this.solver_impl = WRAP.pt3x2_to_qlu();      
        end
        
        function [] = set_solver(this,solver)
            this.solver_impl.solver = solver;
        end
        
        function M = fit(this,x,corresp,idx,cc,varargin)
            x = x(:,[idx{:}]);
            xp = [x(1:3,1:2) x(4:6,1:2) x(7:9,1:2)];
            M = this.solver_impl.fit(xp,[1 3 5; 2 4 6],[1 2 3],cc);
        end
    end
end
