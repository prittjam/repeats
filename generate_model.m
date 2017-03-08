function [model,u_corr,ransac_res,ransac_stats] = ...
    gen_model(dr,G_app,motion_model)
    ransac = make_ransac(G_app,cfg.motion_model);
    [Hinf0,ransac_res,ransac_stats] = ransac.fit(dr,G_app);
    G_sv = verify_geometry(G_app,res.cs);
    u_corr = resection(u,G_sv,Hinfo,cfg.motion_model);
    [U0,Rt_i,u_corr.G_i] = section(u,u_corr,Hinf0);
    [u_corr.G_ij,Rt_ij] = segment_motions(u,u_corr,Hinf0,varargin{:});
    [u_corr,U0,Rt_i,Rt_ij] = ...
        get_valid_motions(u_corr,U0,Rt_i,Rt_ij);
    
    model = struct('Hinf',Hinf0,'q',0.0,'U',U0, ...
                   'Rt_i',Rt_i,'Rt_ij',Rt_ij);
