%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef laf22_to_qH < WRAP.HybridSolver
    properties
        solver_impl = [];
    end
    
    methods
        function this = laf22_to_qH()
            mss = MEAS.make_empty_map();
            mss('rgn') = [2 2];
            this = this@WRAP.HybridSolver(mss);
            this.solver_impl = WRAP.pt5x2_to_qH();
        end

        function M = fit(this,x,idx,cc,varargin)
            x = x{1};
            idx = idx{1};
            x = x(:,[idx{:}]);
            x = [x(1:3,:) x(4:6,:) x(7:9,:)];
            M = this.solver_impl.fit(x, ...
                                     { [1,2],[3,4],[5,6], ...
                                [7,8],[9,10] }, cc);
        end
    end
end
