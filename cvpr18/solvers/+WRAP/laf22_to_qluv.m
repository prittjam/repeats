% Copyright (c) 2017 James Pritts
% 
classdef laf22_to_qluv < WRAP.HybridSolver
    properties
        solver_impl = [];
        input_configs = [];
    end
    
    methods
        function this = laf22_to_qluv(solver_type)
            if nargin < 1
                solver_type = 'det';
            end            
            mss = MEAS.make_empty_map();
            mss('rgn') = [2 2];
            this = this@WRAP.HybridSolver(mss);
            this.solver_impl = ...
                WRAP.pt4x2_to_qluv('solver',solver_type);
            this.input_configs = {mss};
        end
        
        function M = fit(this,x,idx,cc,varargin)
            x = x('rgn');
            if ~isempty(idx)
                xIdx = idx('rgn');
                x = x(:,[xIdx{:}]);
            end
            xp = [x(1:3,1:2) x(4:6,1:2) x(1:3,3:4) x(4:6,3:4)];
            M = this.solver_impl.fit(xp, ...
                                     mat2cell([1 3 5 7;2 4 6 8], ...
                                              2,ones(1,4)),cc);
        end
    end
end
