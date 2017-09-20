classdef GrLo < handle
    properties
        motion_model = [];
        metric_solver = [];
        cc = [];
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
        function this = GrLo(cc,varargin)
            this.cc = cc;
            [this,~] = cmp_argparse(this,varargin{:});
            switch this.motion_model
              case 't'
                this.metric_solver = @this.fit_t;
              case 'Rt'
                this.metric_solver = @this.fit_Rt;
            end
        end
        
        
        function lo_res = fit(this,dr,corresp,res)
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
                resection(x,model0,G_sv,this.motion_model); 

            Hinf = model0.Hinf;
            [rtree,X,Rtij0,Tlist] = ...
                make_scene_graph(x,good_corresp,model0,Rtij00);
            Gm = segment_motions(x,model0,rtree.Edges.EndNodes',Rtij0);
            [Rtij,is_inverted] = fit_motion_centroids(Gm,Rtij0);
            Gs = nan(1,numel(dr));
            inl2 = unique(rtree.Edges.EndNodes);
            Gs(inl2) = findgroups([dr(inl2).Gapp]);
            mle_impl = ...
                MleImpl2(this.cc,x,rtree,Gs,Tlist, ...
                         Gm,is_inverted,0.0,model0.Hinf,X,Rtij);
            [mle_model,mle_stats] = mle_impl.fit('rho','l2');
            inl = find(mle_model.Gs);
           
            % sigma = max([1.4826*mad(err) 1]);
            sigma = 1;
            T = 21.026*sigma^2;
            err2 = T*ones(1,numel(dr));
            err2(~isnan(mle_model.Gs)) = mle_stats.sqerr;
            loss = sum(err2);

            lo_res = struct('M', mle_model, ...
                            'loss', loss, ...
                            'err', err2, ...
                            'cs', err2 < T);
        end
    end
end
%
%            cs = false(1,numel(corresp));
%            [Lia,Locb] = ismember(u_corr1{find(G),{'i','j'}}, ...
%                                  ,'rows');
%            cs(Locb(Lia)) = true; 
%            [Lia,Locb] = ismember(u_corr1{find(G),{'j','i'}}, ...
%                                  corresp','rows');
%            cs(Locb(Lia)) = true; 
%            
%            loss = (numel(cs)-sum(cs))*T+sum(err2);
%            mle_model.u_corr = u_corr1;
