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
        function this = GrLo(labeling,cc,varargin)
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

            u = [dr(:).u];
            
            G_sv = nan(1,numel(dr));
            G_sv(inl) = findgroups([dr(inl).Gapp]);

            Hinf = model0.Hinf; 
            v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*LAF.ru_div(u,model0.cc,model0.q));
            [xform_list,motion_model_list] = ...
                resection(u,v,G_sv,this.motion_model); 
            
%            figure;
%            LAF.draw(gca,v);
%            figure;
%            ii = [xform_list(:).i];
%            for k = 1:numel(xform_list)
%                mtx = Rt.params_to_mtx(xform_list(k).Rt);
%                LAF.draw(gca,blkdiag(mtx,mtx,mtx)*v(:,ii(k)));
%            end
%
            Gm = segment_motions(u,v,model0,xform_list);
            good_ind = find(~isnan(Gm));
            good_xform_list = xform_list(good_ind);
            Gm = Gm(good_ind);

%            ii = [good_xform_list(:).i];
%            for k = 1:max(Gm);
%                idx = find(Gm==k);
%                mtx = Rt.params_to_mtx(good_xform_list(idx(1)).Rt);
%                LAF.draw(gca,blkdiag(mtx,mtx,mtx)*v(:,[good_xform_list(idx).i]));
%            end
%
            Gs = nan(1,numel(dr));
            inl2 = unique([good_xform_list.i good_xform_list.j]);

            Gs(inl2) = findgroups([dr(inl2).Gapp]);
            [rtree,rvertices] = make_scene_graph(v,Gs,Gm,good_xform_list);
            Rtij = fit_motion_centroids(Gm,good_xform_list);
            X = v(:,rvertices);
            [rtree,x] = composite_xforms(rtree,rvertices,Rtij,X);
            draw_reconstruction(gca,rtree,X,Hinf);

            keyboard;
            %            test_draw_reconstruction(gca,rtree,Rtij,Hinf,X,);
            
            new_refine_model(rtree,rvertices,X,Rtij);
            
%            mle_model0 = model0;
%            mle_model0.U = U1;
%            mle_model0.Rt_i = Rt1_i;
%            mle_model0.Rt_ij = Rt1_ij;
%            mle_model0.u_corr = u_corr1;
%            
%            [mle_model,mle_stats] = ...
%                refine_model([dr(:).u],mle_model0.u_corr,mle_model0);
%            
            err = mle_stats.err; 
            %            sigma = max([1.4826*mad(err) 1]);
            sigma = 1;
            err2 = reshape(err.^2,6,[]);
            err2 = [ err2(:,1:end/2); ...
                     err2(:,(end/2+1):end) ];
            err2 = sum(err2);
            T = 21.026*sigma^2
            G = err2 < T;
            
            cs = false(1,numel(corresp));
            [Lia,Locb] = ismember(u_corr1{find(G),{'i','j'}}, ...
                                  corresp','rows');
            cs(Locb(Lia)) = true; 
            [Lia,Locb] = ismember(u_corr1{find(G),{'j','i'}}, ...
                                  corresp','rows');
            cs(Locb(Lia)) = true; 
            
            loss = (numel(cs)-sum(cs))*T+sum(err2);
            mle_model.u_corr = u_corr1;

            lo_res = struct('M', mle_model, ...
                            'loss', loss, ...
                            'err', err2, ...
                            'cs', cs);
        end
    end
end

