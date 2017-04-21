function [model_list,u_corr_list,stats_list] = greedy_repeats(dr,varargin)
cfg.motion_model = 'HG.laf2xN_to_RtxN';
cfg.img = [];
cfg.cc = [];
cfg.rho = 'l2';
cfg.do_distortion = true;
cfg.num_planes = 1;

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

[Gapp,Gr] = group_desc(dr,varargin{:});

Gr = mat2cell(Gr,1,ones(1,numel(Gr)));
[dr(:).reflected] = Gr{:};

dr = add_dr_scale(dr);

for k = 1:cfg.num_planes
    [u_corr0,model0] = generate_model(dr,Gapp,cfg.motion_model,cfg.cc,leftover{:});
    [u_corr,model,stats] = refine_model([dr(:).u],u_corr0,model0);
    
    model_list{k} = model;
    u_corr_list{k} = u_corr;
    stats_list{k} = stats;
    
    Gapp = rm_inliers(u_corr,Gapp);
end
