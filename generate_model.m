function [u_corr,model,ransac_res,ransac_stats] = ...
        generate_model(dr,motion_model,cc,varargin)
    u = [dr(:).u];
    Gapp = [dr(:).Gapp];
    
    ransac = make_ransac(Gapp,motion_model);

    [Hinf0,ransac_res,ransac_stats] = ransac.fit(dr,Gapp);

    G_sv = verify_geometry(Gapp,ransac_res.cs);

    model0 = struct('Hinf',Hinf0, ...
                    'cc', cc, ...
                    'q', 0.0);
    u_corr = resection(u,G_sv,model0,motion_model);
   
    [U0,Rt_i,u_corr.G_i] = section(u,u_corr,model0);
    [u_corr.G_ij,Rt_ij] = segment_motions(u,u_corr,model0,varargin{:});
    model = struct('Hinf',model0.Hinf,'q',model0.q,'U',U0, ...
                   'Rt_i',Rt_i,'Rt_ij',Rt_ij,'cc',model0.cc);
