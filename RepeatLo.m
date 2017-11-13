classdef RepeatLo < handle
    properties
        motion_model = [];
        metric_solver = [];
        cc = [];
        eval = [];
        max_iter = 10;
        
        vqT = 21.026;
        reprojT = 21.026;
    end
    
    methods(Access = private)
        function Ha = fit_t(this,dr,v,G)
            Gr = logical([dr(:).reflected]);            
            Ha = HG.laf2x1_to_Amur(v,G,Gr);
        end
        
        function Ha = fit_Rt(this,dr,v,G)
            Ha = HG.laf2x1_to_Amu(v,G);
        end        
    end

    methods
        function this = RepeatLo(cc,motion_model,varargin)
            this.cc = cc;
            this.eval = ElationEval2db(this.cc);
            this.motion_model = motion_model;
            [this,~] = cmp_argparse(this,varargin{:});
            switch this.motion_model
              case 't'
                this.metric_solver = @this.fit_t;
              case 'Rt'
                this.metric_solver = @this.fit_Rt;
            end
        end

        function [mle_model,mle_res,mle_stats] = fit(this,x,cspond,M00,res,varargin)
            Gsamp = varargin{1};
            Gapp = varargin{2};
            
            N = size(x,2);
            inl_cspond = cspond(:,logical(res.cs)); 

            scspond = inl_cspond(1,:);
            tcspond = inl_cspond(2,:);
            gr = graph(scspond,tcspond,ones(1,numel(scspond)),N);
            Gcomp = conncomp(gr);
            freq = hist(Gcomp,1:max(Gcomp));
            [~,Gmax] = max(freq);
            stons = find(freq==1);
            Gcomp(find(ismember(Gcomp,stons))) = nan;
            G = findgroups(Gcomp);

%            tstinl = find(Gcomp==Gmax);
%            figure;
%            LAF.draw(gca,x(:,tstinl))
%            
            if ~isfield(M00,'q')
                q = 0;
            else
                q = M00.q;
            end
            A = eye(3,3);
%            if (any(LAF.is_right_handed(x(:,inl))))
%                Grect = nan(size(Gapp));  
%                Grect(inl) = findgroups(Gapp(inl));
%                u = LAF.renormI(blkdiag(M00.Hinf,M00.Hinf,M00.Hinf)*...
%                                LAF.ru_div(x,this.cc,q));
%                A = HG.laf1x2_to_Amu(u,Grect);
%                if isempty(A)
%                    A = eye(3);
%                    G = Gsamp;
%                    disp('Metric upgrade failed');
%                else
%                    G = Gapp;
%                end
%            end
           
            M0 = struct('Hinf', A*M00.Hinf, ...
                        'cc', this.cc, ...
                        'q', q);

            [good_cspond,Rtij00] = ...
                resection(x,M0,G,this.motion_model, ...
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
                    PatternPrinter(this.cc,x,rtree,Gs,Tlist, ...
                                   Gm,is_inverted,M0.q,M0.Hinf,X,Rtij, ...
                                   'motion_model', ...
                                   this.motion_model);
                
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

                mle_model.l = transpose(mle_model.Hinf(3,:));
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
