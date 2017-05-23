function [model_list,u_corr_list,stats_list] = greedy_repeats(dr,varargin)
cfg.motion_model = 'Rt';
cfg.img = [];
cfg.cc = [];
cfg.rho = 'l2';
cfg.do_distortion = true;
cfg.num_planes = 1;

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

[Gapp,Gr] = DR.group_desc(dr,varargin{:});

Gr = mat2cell(Gr,1,ones(1,numel(Gr)));
[dr(:).reflected] = Gr{:};

dr = add_dr_scale(dr);
Gapp = DR.group_desc(dr);
Gapp = mat2cell(Gapp,1,ones(1,numel(Gapp)));
[dr(:).Gapp] = Gapp{:};

for k = 1:cfg.num_planes
    [u_corr0,model0] = generate_model(dr,cfg.motion_model,cfg.cc,leftover{:});
    [u_corr,model,stats] = refine_model([dr(:).u],u_corr0,model0);
    [u_corr,model,stats] = prune_model([dr(:).u],u_corr,model);
    
    model_list{k} = model;
    u_corr_list{k} = u_corr;
    stats_list{k} = stats;
    
    %    Gapp = rm_inliers(u_corr,Gapp);
    %    [dr(:).Gapp] = Gapp{:};
end
