%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef laf2_to_lu < WRAP.HybridSolver
    properties
        solver_impl = [];
    end
    
    methods
        function this = laf2_to_lu()
            mss = MEAS.make_empty_map();
            mss('rgn') = [2];
            this = this@WRAP.HybridSolver(mss);
            this.solver_impl = WRAP.pt2x2_to_lu();
        end

        function M = fit(this,x,idx,varargin)
            x = x{1};
            idx = idx{1};
            x = x(:,idx{:});
            xp = [x(1:3,:) x(4:6,:) x(7:9,:)];
            M = this.solver_impl.fit(xp,mat2cell([1 3 5; 2 4 6],2,ones(1,3)));
        end
    end
end
