classdef RepeatLo < handle
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
        function this = RepeatLo(cc,motion_model,varargin)
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

        function [mle_model,mle_res,mle_stats] = fit(this,x,corresp,M00,res,varargin)
            Gsamp = varargin{1};
            Gapp = varargin{2};
            inl = unique(corresp(:,logical(res.cs)));            
            
            if ~isfield(M00,'q')
                q = 0
            else
                q = M00.q;
            end
            Hinf = M00.Hinf;

            G = Gsamp;
            A = eye(3);
            M0 = struct('Hinf', A*Hinf, ...
                        'cc', this.cc, ...
                        'q', q);
            
            N = size(x,2);
            G_sv = nan(1,N);
            G_sv(inl) = findgroups(G(inl));

            [good_corresp,Rtij00] = ...
                resection(x,M0,G_sv,this.motion_model, ...
                          'vqT',this.vqT); 
            
            mle_stats = [];
            mle_model = [];

            err2 = inf*ones(1,numel(G));
            mle_res = struct('loss', inf, ...
                             'err', err2, ...
                             'cs', false(1,numel(G))); 
            
            if ~isempty(good_corresp)
                [rtree,X,Rtij0,Tlist] = ...
                    make_scene_graph(x,good_corresp,M0,Rtij00,'vqT',this.vqT);
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
                figure;
                plot(sq_err_tmp);


                [mle_model,mle_stats] = ...
                    pattern_printer.fit('MaxIterations',this.max_iter);

                err2 = this.reprojT*ones(1,N);
                err2(~isnan(mle_model.Gs)) = mle_stats.sqerr;
                loss = sum(err2);
            
                if isreal(loss)
                    mle_res = struct('loss', loss, ...
                                     'err', err2, ...
                                     'cs', err2 < this.reprojT);
                end
            end
        end
    end
end
