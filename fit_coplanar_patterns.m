function [model_list,stats_list] = ...
    fit_coplanar_patterns(solver,x,Gsamp,Gapp,cc,num_planes,varargin)

[ransac,corresp] = make_ransac(solver,x,Gsamp,Gapp,cc,varargin);

for k = 1:num_planes  
    [model0,res0,~,~,stats_list(k)] = ...
        ransac.fit(x,corresp,Gsamp,Gapp);
    [loss,E] = ransac.eval.calc_loss(x,corresp,model0);
    cs = ransac.eval.calc_cs(E);
    res = struct('cs',cs);
    ransac.lo.max_iter = 10;
    [model_list(k),lo_res] = ...
        ransac.lo.fit(x,corresp,model0,res,Gsamp,Gapp);
end
