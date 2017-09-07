function [model,corresp,ransac_res,ransac_stats] = ...
        generate_model(dr,motion_model,cc,varargin)
    u = [dr(:).u];
    Gapp = [dr(:).Gapp];
    corresp = cmp_splitapply(@(u) { VChooseK(u,2)' }, ...
                             1:numel(Gapp),Gapp);
    corresp = [ corresp{:} ];
    ransac = make_ransac(dr,corresp,cc,motion_model);
    [model,ransac_res,ransac_stats] = ransac.fit(dr,corresp);

 %    G_sv = verify_geometry(Gapp,ransac_res.cs);

%    G_sv = nan(1,numel(dr));
%    valid_sv = unique(corresp(:,logical(ransac_res.cs))); 
%    G_sv(valid_sv) = findgroups([dr(valid_sv).Gapp]);
%    
%    model0 = struct('Hinf',Hinf0, ...
%                    'cc', cc, ...
%                    'q', 0.0);
%    u_corr = resection(u,G_sv,model0,motion_model);
%    [U0,Rt_i,u_corr.G_i] = section(u,u_corr,model0,motion_model);
%    [u_corr.G_ij,Rt_ij] = segment_motions(u,u_corr,model0,varargin{:});
%    model = struct('Hinf',model0.Hinf,'q',model0.q,'U',U0, ...
%                   'Rt_i',Rt_i,'Rt_ij',Rt_ij,'cc',model0.cc);
