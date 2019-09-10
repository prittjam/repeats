%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef laf22_to_q1q2H < WRAP.RectSolver
    properties
        solver_impl = [];
    end
    
    methods
        function this = laf22_to_q1q2H()
            this = this@WRAP.RectSolver('22s');
            this.solver_impl = WRAP.pt5x2_to_q1q2H();
        end

        function M = fit(this,x,idx,cc,varargin)
            x = x(:,[idx{:}]);
            x = [x(1:3,:) x(4:6,:) x(7:9,:)];
            M = this.solver_impl.fit(x, ...
                                     [1 3 5 7 9; 2 4 6 8 10],cc);
            
        end
    end
end
