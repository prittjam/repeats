function [model_list,stats_list] = greedy_repeats(dr,varargin)
cfg.motion_model = 'Rt';
cfg.img = [];
cfg.cc = [];
cfg.rho = 'l2';
cfg.do_distortion = true;
cfg.num_planes = 1;

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

for k = 1:cfg.num_planes
    [model0,corresp,ransac_stats] = ...
        generate_model(dr,cfg.motion_model,cfg.cc,leftover{:});
%    model = do_lo(dr,cfg.motion_model,corresp,model0);
%    model = prune_model(model0);
%    
    model_list{k} = model;
    stats_list{k} = ransac_stats;
    %    Gapp = rm_inliers(u_corr,Gapp);
    %    [dr(:).Gapp] = Gapp{:};
end


function mle_model = do_lo(dr,motion_model,corresp,model0)
   eval2 = GrEval2();
   [~,E] = eval2.calc_loss(dr,corresp,model0.Hinf);
   cs = eval2.calc_cs(E);
   inl = unique(corresp(:,logical(cs)));
   
   u = [dr(:).u];
   G_sv = nan(1,numel(dr));
   G_sv(inl) = findgroups([dr(inl).Gapp]);
   
   u_corr0 = resection(u,G_sv,model0,motion_model);
   [U0,Rt0_i,u_corr0.G_i] = section(u,u_corr0,model0,motion_model);
   [u_corr0.G_ij,Rt0_ij] = segment_motions(u,u_corr0,model0);
   
   [u_corr1,U1,Rt1_i,Rt1_ij] = get_valid_motions(u_corr0,U0,Rt0_i,Rt0_ij);
   
   mle_model0 = model0;
   mle_model0.U = U1;
   mle_model0.Rt_i = Rt1_i;
   mle_model0.Rt_ij = Rt1_ij;
   mle_model0.u_corr = u_corr1;
   
   [mle_model,mle_stats] = ...
       refine_model([dr(:).u],mle_model0.u_corr,mle_model0);
