classdef GrLo < handle
    properties
        motion_model = [];
        metric_solver = [];
        cc = [];
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
        function this = GrLo(cc,motion_model,varargin)
            this.cc = cc;
            this.motion_model = motion_model;
            [this,~] = cmp_argparse(this,varargin{:});
            switch this.motion_model
              case 't'
                this.metric_solver = @this.fit_t;
              case 'Rt'
                this.metric_solver = @this.fit_Rt;
            end
        end
        
        
        function [mle_model,mle_res,mle_stats] = fit(this,dr,corresp,res,varargin)
            cfg = struct('MaxIterations',10);
            cfg = cmp_argparse(cfg,varargin{:});
            
            inl = unique(corresp(:,logical(res.cs)));
            G = findgroups([dr(inl).Gapp]);
            u = [dr(inl).u];
            Hp = HG.laf2x2_to_Hinf(u,G);            
 
            v = LAF.renormI(blkdiag(Hp,Hp,Hp)*u);
            Ha = this.fit_Rt(dr,v,G);

            if isempty(Ha)
                model0 = struct('Hinf',Hp, ...
                                'cc', this.cc, ...
                                'q', 0.0);
            else
                model0 = struct('Hinf',Ha*Hp, ...
                                'cc', this.cc, ...
                                'q', 0.0);
            end

            x = [dr(:).u];
            
            G_sv = nan(1,numel(dr));
            G_sv(inl) = findgroups([dr(inl).Gapp]);

            [good_corresp,Rtij00] = ...
                resection(x,model0,G_sv,this.motion_model, ...
                          'vqT',this.vqT); 

            if ~isempty(good_corresp)
                Hinf = model0.Hinf;
                [rtree,X,Rtij0,Tlist] = ...
                    make_scene_graph(x,good_corresp,model0,Rtij00);
                Gm = segment_motions(x,model0,rtree.Edges.EndNodes',Rtij0, ...
                                     'vqT',this.vqT);
                [Rtij,is_inverted] = fit_motion_centroids(Gm,Rtij0);
                Gs = nan(1,numel(dr));
                inl2 = unique(rtree.Edges.EndNodes);
                Gs(inl2) = findgroups([dr(inl2).Gapp]);
                pattern_printer = ...
                    PatternPrinter(this.cc,x,rtree,Gs,Tlist, ...
                                   Gm,is_inverted,0.0,model0.Hinf,X,Rtij, ...
                                   'motion_model',this.motion_model);
                [mle_model,mle_stats] = ...
                    pattern_printer.fit('MaxIterations',cfg.MaxIterations);
                
                inl = find(mle_model.Gs);
                
                err2 = this.reprojT*ones(1,numel(dr));
                err2(~isnan(mle_model.Gs)) = mle_stats.sqerr;
                loss = sum(err2);
            
                mle_res = struct('loss', loss, ...
                                 'err', err2, ...
                                 'cs', err2 < this.reprojT);
            else
                mle_stats = [];
                mle_model = [];
                err2 = inf*ones(1,numel(dr));
                mle_res = struct('loss', inf, ...
                                 'err', err2, ...
                                 'cs', false(1,numel(dr)));
            end
        end
    end
end
