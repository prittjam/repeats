%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef laf2_to_lu < WRAP.LafRectSolver
    properties
        solver_impl = [];
    end
    
    methods
        function this = laf2_to_lu(cc)
            this = this@WRAP.LafRectSolver(2);
            this.solver_impl = WRAP.pt2x2_to_lu(cc);
        end

        function M = fit(this,x,corresp,idx,varargin)
            m = corresp(:,idx(1));
            x = x(:,m(:));
            xp = [x(1:3,:) x(4:6,:) x(7:9,:)];
            M = this.solver_impl.fit(xp,[1 3 5; 2 4 6],[1 2 3]);
        end
    end
end
