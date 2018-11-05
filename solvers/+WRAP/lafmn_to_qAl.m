%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
% Copyright (c) 2017 James Pritts
% 
classdef lafmn_to_qAl < WRAP.RectSolver
    properties
        solver_impl = [];
    end
    
    methods
        function this = lafmn_to_qAl(solver_impl)
            this = this@WRAP.RectSolver(solver_impl.sample_type); 
            this.solver_impl = solver_impl;
        end

        function M = fit(this,x,corresp,idx,varargin)            
            M = this.solver_impl.fit(x,corresp,idx,varargin{:});
            Gsamp = varargin{2};
            m = [idx{:}];        
            
            for k = 1:numel(M)
                H = eye(3);
                H(3,:) = transpose(M(k).l);
                xp = ...
                    PT.renormI(blkdiag(H,H,H)*PT.ru_div(x,M(k).cc,M(k).q));
                A{k} = laf2_to_Amu(xp(:,m),findgroups(Gsamp(m))); 
            end         
            if numel(M) > 0;
                [M(:).A] = A{:};
                good_ind = arrayfun(@(x) ~isempty(x.A),M);
                M = M(good_ind); 
            end
        end
    end
end 