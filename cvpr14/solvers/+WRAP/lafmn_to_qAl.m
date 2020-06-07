%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
% Copyright (c) 2017 James Pritts
% 
classdef lafmn_to_qAl < WRAP.HybridSolver
    properties
        solver_impl = [];
        upgrade_type = 'scale_consensus';
        upgrade_fn = @laf2_to_Amu;
    end
    
    methods(Static)
        function G = calc_inliers(xp,idx,varargin)
            G = findgroups(varargin{2});
            sc = abs(LAF.calc_scale(xp));
            inl = false(size(sc));
            scale_thresh = 0.1;
            for k = 1:max(G)
                idx = find(G == k);
                scidx = sc(idx);
                mscidx = median(scidx);
                lgscratio = log10(scidx/mscidx);
                idxinl = log10(0.95)  < lgscratio & ...
                         lgscratio < log10(1.05);
                inl(idx(idxinl)) = true;
            end
            G(~inl) = nan;
            G = findgroups(G);
        end
        
        function [A,l] = minimal_metric(x,idx,M0,varargin)
            l = M0.l;
            cc = varargin{2};
            Hinf = eye(3);
            Hinf(3,:) = transpose(M0.l);
            xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)* ...
                            PT.ru_div(x,cc,M0.q));
            G = findgroups(varargin{2});
            m = [idx{:}];
            A = laf2_to_Amu(xp(:,m),findgroups(G(m))); 
        end
               
        function A = minimal_semimetric(xp,idx,varargin)
            G = findgroups(varargin{2});
            m = [idx{:}];
            A = laf2_to_Amu(xp(:,m),findgroups(G(m))); 
        end
        
    end
    
    methods
        function this = lafmn_to_qAl(solver_impl,varargin)
            this = this@WRAP.RectSolver(solver_impl.sample_type); 
            this.solver_impl = solver_impl;
            this = cmp_argparse(this,varargin{:});
        end
        
        function [A,l] = scale_consensus_upgrade(this,x,idx,M0,varargin)           
            l = M0.l;
            A = [];
            cc = varargin{1};
            Hinf = eye(3);
            Hinf(3,:) = transpose(M0.l);
            xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)* ...
                            PT.ru_div(x,cc,M0.q));
            G = WRAP.lafmn_to_qAl.calc_inliers(xp,idx,varargin{:});
            if any(~isnan(G))
                xu = PT.ru_div(x,cc,M0.q);
                %l = laf22_to_l(xu,G);
                Hinf = eye(3);
                Hinf(3,:) = transpose(l);
                xp = RP2.renormI(blkdiag(Hinf,Hinf,Hinf)*xu);
                A = this.upgrade_fn(xp,G);
            end
        end

        function model_list = fit(this,x,idx,varargin)
            M = this.solver_impl.fit(x,idx,varargin{:});
            x = x('rgn');
            idx = idx('rgn');
            cc = varargin{1};

            if isempty(M)
                model_list = [];
            else
                for k = 1:numel(M)
                    switch this.upgrade_type
                      case 'minimal'
                        [A,l] = ...
                            WRAP.lafmn_to_qAl.minimal_metric(x,idx, ...
                                                             varargin{:});
                      case 'scale_consensus'
                        [A,l] = this.scale_consensus_upgrade(x,idx,M(k),varargin{:});
                      otherwise
                        throw;
                    end
                    
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
                    
                    Hp = eye(3);
                    Hp(3,:) = l;
                    H = A*Hp;
                    
                    model_list(k) = struct('l',l, ...
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