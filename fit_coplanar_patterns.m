function [model_list,stats_list] = fit_patterns(dr,corresp,ransac,num_planes)
for k = 1:num_planes
    [model0,~,~,stats_list(k)] = ransac.fit(dr,corresp);
    [loss,E] = eval.calc_loss(dr,corresp,model0);
    cs = eval.calc_cs(E);
    res = struct('cs',cs);
    [model_list(k),lo_res] = lo.fit(dr,corresp,res, ...
                                    'MaxIterations',30);
end
