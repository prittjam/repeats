%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef RepeatLo < handle
    properties
        eval = [];
        max_iter = 10;
        %           vqT = 21.026;
        %  reprojT = 21.026;
        %    
        vqT = 15;
        reprojT = 15;
    end

    methods
        function this = RepeatLo(motion_model,varargin)
            this.eval = RepeatEval();
            [this,~] = cmp_argparse(this,varargin{:});
        end

        function [mle_model,mle_res,mle_stats] = fit(this,x,M00,res,varargin)
            inl = find(res.cs);
            Gsamp = varargin{end-1};
            Gapp = varargin{end};
            N = size(x,2);
            %            G = separate_look_alikes(x,cspond,res);
            G = nan(size(Gapp));
            G(inl) = findgroups(Gapp(inl));
            
            if ~isfield(M00,'q')
                q = -1e-9;
            else
                q = M00.q;
            end

            A = M00.A;
            H = eye(3);
            H(3,:) = transpose(M00.l);            
%            assert(istriu(M00.A), ...
%                   'metric upgrade is not upper triangular!');
            H = A*H;
            xp = PT.renormI(blkdiag(H,H,H)*PT.ru_div(x(:,inl),M00.cc,q));
            M0 = struct('H',H, ...
                        'cc',M00.cc, ...
                        'q', q);
            
            [good_cspond,Rtij00] = ...
                resection(x,M0,G,'Rt', ...
                          'vqT',this.vqT); 
            
            mle_stats = [];
            mle_model = [];

            err2 = inf*ones(1,N);
            mle_res = struct('loss', inf, ...
                             'err', err2, ...
                             'cs', false(1,N)); 
            
            if ~isempty(good_cspond)
                [rtree,X,Rtij0,Tlist] = ...
                    make_scene_graph(x,good_cspond,M0,Rtij00,'vqT',this.vqT);
                Gm = segment_motions(x,M0,rtree.Edges.EndNodes',Rtij0, ...
                                     'vqT',this.vqT);

                [Rtij,is_inverted] = fit_motion_centroids(Gm,Rtij0);
                Gs = nan(1,N);
                inl2 = unique(rtree.Edges.EndNodes);

                Gs(inl2) = findgroups(G(inl2));
                
                pattern_printer = ...
                    PatternPrinter(M00.cc,x,rtree,Gs,Tlist, ...
                                   Gm,is_inverted,q,A,M00.l,X,Rtij, ...
                                   'motion_model', ...
                                   'Rt');
                
                err0 = pattern_printer.calc_err();
                sq_err = sum(sum(reshape(err0,6,[]).^2));
                
                sq_err_tmp = sum(reshape(err0,6,[]).^2);

                [mle_model,mle_stats] = ...
                    pattern_printer.fit('MaxIterations',this.max_iter);

                err2 = this.reprojT*ones(1,N);
                err2(~isnan(mle_model.Gs)) = mle_stats.sqerr;
                
                err2robust = err2;
                err2robust(err2>this.reprojT) = this.reprojT;
                loss = sum(err2robust);

                unary_cs = err2 < this.reprojT;

                >%                mle_model.l = transpose(mle_model.Hinf(3,:));
                [loss,E] = this.eval.calc_loss(x,cspond,mle_model);
                cs = this.eval.calc_cs(E);
                
                mle_res = struct('loss', loss, ...
                                 'err', err2, ...
                                 'cs', cs);                

                %                if isreal(loss) && sum(unary_cs) > 0
                %                    induced_cspond = ...
                %                        cmp_splitapply(@(x) { VChooseK(x,2)' }, ...
                %                                       find(unary_cs), ...
                %                                       findgroups(Gsamp(find(unary_cs))));
                %                    induced_cspond = [induced_cspond{:}];
                %                    
                %                    [~,Lib1] = ismember(induced_cspond',cspond','rows');
                %                    %                [~,Lib2] = ismember([induced_cspond(2,:); ...
                %                    %                                    induced_cspond(1,:)]', cspond','rows');
                %                    cs = false(size(res.cs));
                %                    cs(Lib1) = true;
                %                    mle_res = struct('loss', loss, ...
                %                                     'err', err2, ...
                %                                     'unary_cs', err2 < this.reprojT, ...
                %                                     'cs', cs);                    
                %
                %                end
            end
        end
    end
end
