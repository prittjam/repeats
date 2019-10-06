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
    
    methods(Static)
        function A = minimal_upgrade(xp,idx,M,varargin)
            G = findgroups(varargin{2});
            m = [idx{:}];
            A = laf2_to_Amu(xp(:,m),findgroups(G(m))); 
        end
        
        function A = inliers_upgrade(xp,idx,varargin)           
            G = findgroups(varargin{2});
            sc = abs(LAF.calc_scale(xp));
            inl = false(size(sc));
            scale_thresh = 0.1;
            for k = 1:max(G)
                idx = find(G == k);
                scidx = sc(idx);
                mscidx = median(scidx);
                lgscratio = log10(scidx/mscidx);
                idxinl = log10(0.925)  < lgscratio & lgscratio < ...
                         log10(1.075);
                inl(idx(idxinl)) = true;
            end
            G(~inl) = false;
            A = laf2_to_Amu(xp,findgroups(G));             
        end
    end
    
    methods
        function this = lafmn_to_qAl(solver_impl,upgrade_impl)
            this = this@WRAP.RectSolver(solver_impl.sample_type); 
            this.solver_impl = solver_impl;
        end

        function model_list = fit(this,x,idx,varargin)            
            M = this.solver_impl.fit(x,idx,varargin{:});
            cc = varargin{1};

            if isempty(M)
                model_list = [];
            else
                for k = 1:numel(M)
                    Hinf = eye(3);
                    Hinf(3,:) = transpose(M(k).l);
                    xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)* ...
                                    PT.ru_div(x,cc,M(k).q));
                    A = WRAP.lafmn_to_qAl.inliers_upgrade(xp,idx,varargin{:});

                    upgrade_succeeded = true;
                    if isempty(A)
                        upgrade_succeeded = false;
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
                                           'cc',cc, ...
                                           'H', H, ...
                                           'solver_time',M(k).solver_time);
                end         
            end
        end
    end
end 