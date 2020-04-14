%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef laf2_to_ql < WRAP.HybridRectSolver
    properties
        solver_impl = []
    end

    methods
        function this = laf2_to_ql(varargin)
            this = this@WRAP.HybridRectSolver('r2');   
            this.solver_impl = WRAP.pt3x2_to_ql(varargin{:});
        end

        function M = fit(this,x,idx,cc,varargin)
            x = x(:,[idx{:}]);
            xp = [x(1:3,1:2) x(4:6,1:2) x(7:9,1:2)];
            M = this.solver_impl.fit(xp,[1 3 5; 2 4 6],cc);
        end
    end
end
