function [model_list,lo_res_list,stats_list] = ...
    fit_coplanar_patterns(solver,x,Gsamp,Gapp,cc,num_planes,varargin)

[ransac,corresp] = make_ransac(solver,x,Gsamp,Gapp,cc,varargin);

for k = 1:num_planes  
    [model0(k),res0(k),model00(k),res00(k),stats_list(k)] = ...
        ransac.fit(x,corresp,Gsamp,Gapp);
%    [loss,E] = ransac.eval.calc_loss(x,corresp,model0);
%    cs = ransac.eval.calc_cs(E);
%    res = struct('cs',cs);

    ransac.lo.max_iter = 20;
    [model_list(k),lo_res_list(k)] = ...
        ransac.lo.fit(x,corresp,model0,res0,Gsamp,Gapp);
end
