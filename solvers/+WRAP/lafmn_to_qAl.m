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
        solver_type = 'inliers_metric'
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
        
        function A = minimal_metric(x,idx,varargin)
            cc = varargin{2};
            Hinf = eye(3);
            Hinf(3,:) = transpose(M0.l);
            xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)* ...
                            PT.ru_div(x,cc,M0.q));
            G = findgroups(varargin{2});
            m = [idx{:}];
            A = laf2_to_Amu(xp(:,m),findgroups(G(m))); 
        end
        
        function A = inliers_metric(x,idx,M0,varargin)           
            A = [];
            cc = varargin{1};
            Hinf = eye(3);
            Hinf(3,:) = transpose(M0.l);
            xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)* ...
                            PT.ru_div(x,cc,M0.q));
            G = WRAP.lafmn_to_qAl.calc_inliers(xp,idx,varargin{:});
            if any(~isnan(G))
                xu = PT.ru_div(x,cc,M0.q);
                l = laf22_to_l(xu,G);
                Hinf = eye(3);
                Hinf(3,:) = transpose(M0.l);
                xp = RP2.renormI(blkdiag(Hinf,Hinf,Hinf)*xu);
                A = laf2_to_Amu(xp,G);
            end
        end
        
        function A = minimal_semimetric(xp,idx,varargin)
            G = findgroups(varargin{2});
            m = [idx{:}];
            A = laf2_to_Amu(xp(:,m),findgroups(G(m))); 
        end
        
        function A = inliers_semimetric(xp,idx,varargin)           
            Ginl = WRAP.lafmn_to_qAl.calc_inliers(xp,idx,varargin{:});
            A = laf2_to_Amur(xp,Ginl);             
        end
        
    end
    
    methods
        function this = lafmn_to_qAl(solver_impl,varargin)
            this = this@WRAP.RectSolver(solver_impl.sample_type); 
            this.solver_impl = solver_impl;
            
            this = cmp_argparse(this,varargin{:});
        end

        function model_list = fit(this,x,idx,varargin)            
            M = this.solver_impl.fit(x,idx,varargin{:});
            cc = varargin{1};

            if isempty(M)
                model_list = [];
            else
                for k = 1:numel(M)
                    switch this.solver_type
                      case 'minimal_metric'
                        A = ...
                            WRAP.lafmn_to_qAl.minimal_metric(x,idx,varargin{:});                        
                      case 'inliers_metric'
                        A = ...
                            WRAP.lafmn_to_qAl.inliers_metric(x,idx,M(k),varargin{:});                        
                      case 'minimal_semimetric'
                        A = ...
                            WRAP.lafmn_to_qAl.minimal_semimetric(x,idx,varargin{:});
                      case 'inliers_semimetric'
                        A = ...
                            WRAP.lafmn_to_qAl.inliers_semimetric(x,idx,varargin{:});
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
                    Hp(3,:) = M(k).l;
                    H = A*Hp;

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