function [model,corresp,ransac_res,ransac_stats] = ...
        generate_model(dr,motion_model,cc,varargin)
    u = [dr(:).u];
    Gapp = [dr(:).Gapp];
    corresp = cmp_splitapply(@(u) { VChooseK(u,2)' }, ...
                             1:numel(Gapp),Gapp);
    corresp = [ corresp{:} ];
    ransac = make_ransac(dr,corresp,cc,motion_model);
    [model,ransac_res,ransac_stats] = ransac.fit(dr,corresp);
