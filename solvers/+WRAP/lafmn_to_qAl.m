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

        function M = fit(this,x,idx,varargin)            
            M = this.solver_impl.fit(x,idx,varargin{:});
            Gsamp = varargin{2};
            m = [idx{:}];        

            for k = 1:numel(M)
                H = eye(3);
                H(3,:) = transpose(M(k).l);
                xp = ...
                    PT.renormI(blkdiag(H,H,H)*PT.ru_div(x,M(k).cc, ...
                                                        M(k).q));
                                A{k} = laf2_to_Amu(xp(:,m),findgroups(Gsamp(m))); 
%                [A{k},l{k}] = ...
%                    laf2_vl_to_Hmr(xp,corresp,idx,M(k).cc,M(k).l);
            end         
            
            if ~isempty(M)
                bad_ind = cellfun(@(x) isempty(x),A);
                A(bad_ind) =  ...
                    squeeze(mat2cell(repmat(eye(3,3),1,1,sum(bad_ind)),...
                                     3,3,ones(1,sum(bad_ind)))); 
                good_ind = ~bad_ind;                          
                if exist('l')
                    if any(good_ind)
                        [M(good_ind).l] = l{good_ind};
                    end
                end
                [M(:).A] = A{:};
            end
        end
    end
end 