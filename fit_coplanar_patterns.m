function [model_list,stats_list] = fit_coplanar_patterns(dr,corresp,ransac,num_planes)
x = [dr(:).u];
Gsamp = [dr(:).Gsamp];
Gapp = [dr(:).Gapp];

for k = 1:num_planes  
    [model0,res0,~,~,stats_list(k)] = ...
        ransac.fit(x,corresp,Gsamp,Gapp);
    [loss,E] = ransac.eval.calc_loss(x,corresp,model0);
    cs = ransac.eval.calc_cs(E);
    res = struct('cs',cs);
    [model_list(k),lo_res] = ...
        ransac.lo.fit(x,corresp,model0,res,Gsamp,Gapp);
end
