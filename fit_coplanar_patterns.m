function [model_list,stats_list] = fit_coplanar_patterns(dr,corresp,ransac,num_planes)
for k = 1:num_planes
    [model0,res0,~,~,stats_list(k)] = ransac.fit(dr,corresp);
    [loss,E] = ransac.eval.calc_loss(dr,corresp,model0);
    cs = ransac.eval.calc_cs(E);
    res = struct('cs',cs);
    [model_list(k),lo_res] = ransac.lo.fit(dr,corresp,model0, ...
                                           res,'MaxIterations',30);
end
