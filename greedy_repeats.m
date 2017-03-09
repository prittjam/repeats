function [res_list,stats_list,res0] = greedy_repeats(dr,varargin)
cfg.motion_model = 'HG.laf2xN_to_RtxN';
cfg.img = [];
cfg.cc = [];
cfg.rho = 'l2';
cfg.do_distortion = true;
cfg.num_planes = 1;

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

G_app = group_desc(dr,varargin{:});

for k = 1:cfg.num_planes
    [model0,u_corr0] = generate_model(dr,G_app,cfg.motion_model,leftover{:});
    [model,stats] = refine_model([dr(:).u],u_corr0,cfg.cc,model0);
    G_app = rm_inliers(u_corr,G_app);
    res_list{k} = res;
    stats_list{k} = stats;
end


%keyboard;

%for k = 1:max(G_app)
%    figure;imshow(cfg.img);
%    LAF.draw(gca,u(:,G_app==k),'LineWidth',2);
%end
%Gr = get_reflections(dr,G_app);

%tst = intersect(G_app(find([dr(:).reflected]==1)),G_app(find([dr(:).reflected]==0)))
%keyboard;
%
%indo = find([dr(:).reflected] == 0);
%indr = find([dr(:).reflected] == 1);
%figure;
%imshow(cfg.img);
%LAF.draw_groups(gca,u,G_app);
%keyboard;
%
%figure;
%imshow(cfg.img);
%LAF.draw_groups(gca,u(:,indo),G_app(indo));
%figure;
%imshow(cfg.img);
%LAF.draw_groups(gca,u(:,indr),G_app(indr));
%
%figure;
%imshow(cfg.img);
%LAF.draw_groups(gca,u,G_app,'LineWidth',3);
%
