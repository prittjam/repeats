% Copyright (c) 2017 James Pritts
% 
classdef laf22_to_qH < WRAP.LafRectSolver
    properties
        solver_impl = [];
    end
    
    methods
        function this = laf22_to_qH(cc)
            this = this@WRAP.LafRectSolver('laf22s');
            this.solver_impl = WRAP.pt5x2_to_qH(cc);
        end

        function M = fit(this,x,corresp,idx,varargin)
            m = corresp(:,idx);
            x = x(:,m(:));
            x = [x(1:3,:) x(4:6,:) x(7:9,:)];
            M = this.solver_impl.fit(x, ...
                                     [1 3 5 7 9; 2 4 6 8 10], ...
                                     [1 2 3 4 5]);
        end

    end
end
