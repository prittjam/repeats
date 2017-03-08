function [res_list,stats_list,res0] = greedy_repeats(dr,varargin)
cfg.motion_model = 'HG.laf2xN_to_RtxN';
cfg.img = [];
cfg.cc = [];
cfg.rho = 'l2';
cfg.do_distortion = true;
cfg.num_planes = 1;

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

u = [dr(:).u];
G_app = group_desc(dr,varargin{:});

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

for k = 1:cfg.num_planes
    ransac = make_ransac(G_app,cfg.motion_model);
    [Hinf0,res,stats] = ransac.fit(dr,G_app);

    G_sv = verify_geometry(G_app,res.cs);
    u_corr = resection(v,G_sv,cfg.motion_model);
    [U0,Rt_i,u_corr.G_i] = section(u,u_corr,Hinf0);
    [u_corr.G_ij,Rt_ij] = segment_motions2(u,u_corr,Hinf0,varargin{:});
    [u_corr,U0,Rt_i,Rt_ij] = get_valid_motions(u_corr,U0,Rt_i,Rt_ij);

    res0 = struct('Hinf',Hinf0,'q',0.0,'U',U0, ...
                  'Rt_i',Rt_i,'Rt_ij',Rt_ij);
    rho = 'geman_mcclure';
    mle_impl = MleImpl(u,u_corr,cfg.cc,res0);
    [res,stats] = mle_impl.fit('rho',rho);

    G0 = label_outliers(stats.err0);
    res0.G = G0;
    res0.u_corr = u_corr;

    G = label_outliers(stats.err);

    u_corr = u_corr(logical(G),:);
    mle_impl = MleImpl(u,u_corr,cfg.cc,res);
    rho = 'l2';
    [res,stats] = mle_impl.fit('rho',rho);

    res.rd_div = struct('q',res.q, ...
                        'cc', cfg.cc);
    res.u_corr = u_corr;
    res.G = G;
    rmfield(res,'q');

    G_app = rm_inliers(u_corr,G_app);
    
    res_list{k} = res;
    stats_list{k} = stats;
end
