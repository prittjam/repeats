% Copyright (c) 2017 James Pritts
% 
classdef lafmn_to_qAl < WRAP.LafRectSolver
    properties
        solver_impl = [];
    end
    
    methods
        function this = lafmn_to_qAl(solver_impl)
            this = this@WRAP.LafRectSolver(solver_impl.sample_type); 
            this.solver_impl = solver_impl;
        end

        function M = fit(this,x,corresp,idx,varargin)            
            M = this.solver_impl.fit(x,corresp,idx,varargin{:});
            Gsamp = varargin{1};
            m = [idx{:}];                
            for k = 1:numel(M)
                H = eye(3);
                H(3,:) = transpose(M(k).l);
                xp = ...
                    LAF.renormI(blkdiag(H,H,H)*LAF.ru_div(x,M(k).cc,M(k).q));
                A{k} = laf2_to_Amu(xp(:,m),findgroups(Gsamp(m))); 
            end         
            [M(:).A] = A{:};
            good_ind = arrayfun(@(x) ~isempty(x.A),M);
            M = M(good_ind);
        end
    end
end 
