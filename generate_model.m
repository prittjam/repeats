function [u_corr,model,ransac_res,ransac_stats] = ...
        generate_model(dr,G_app,motion_model,cc,varargin)

    u = [dr(:).u];

    ransac = make_ransac([dr(:).Gapp],motion_model);
    [Hinf0,ransac_res,ransac_stats] = ransac.fit(dr,G_app);
    G_sv = verify_geometry(G_app,ransac_res.cs);
    u_corr = resection(u,G_sv,Hinf0,motion_model);

    [U0,Rt_i,u_corr.G_i] = section(u,u_corr,Hinf0);
    [u_corr.G_ij,Rt_ij] = segment_motions(u,u_corr,Hinf0,varargin{:});
    model = struct('Hinf',Hinf0,'q',0.0,'U',U0, ...
                   'Rt_i',Rt_i,'Rt_ij',Rt_ij,'cc',cc);
