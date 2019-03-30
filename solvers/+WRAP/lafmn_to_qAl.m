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

        function model_list = fit(this,x,idx,varargin)            
            M = this.solver_impl.fit(x,idx,varargin{:});
            G = findgroups(varargin{2});
            m = [idx{:}];
            keyboard;
            if isempty(M)
                model_list = [];
            else
                for k = 1:numel(M)
                    Hinf = eye(3);
                    Hinf(3,:) = transpose(M(k).l);
                    xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)*PT.ru_div(x,M(k).cc,M(k).q));
                    A = laf2_to_Amu(xp(:,m),findgroups(G(m))); 

                    if isempty(A)
                        A = eye(3);
                    end

                    if ~isfield(M,'q')
                        q = 0;
                    else
                        q = M(k).q;
                    end

                    H = A*Hinf;

                    model_list(k) = struct('l',M(k).l, ...
                                           'A',A, ...
                                           'q',q, ...
                                           'cc',M(k).cc, ...
                                           'H', H, ...
                                           'solver_time',M(k).solver_time);
                end         
            end
        end
    end
end 