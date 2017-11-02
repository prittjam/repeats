function [model_list,stats_list] = fit_coplanar_patterns(x,Gsamp,Gapp,cc,num_planes)
corresp = cmp_splitapply(@(u) { VChooseK(u,2)' }, ...
                         1:numel(Gsamp),Gsamp);
corresp = [ corresp{:} ];

factory = RansacFactory();
ransac = factory.make('$\mH3\vl\vu s_{\vu}\lambda$', ...
                      x,corresp,cc,Gsamp,Gapp);

for k = 1:num_planes  
    [model0,res0,~,~,stats_list(k)] = ...
        ransac.fit(x,corresp,Gsamp,Gapp);
    [loss,E] = ransac.eval.calc_loss(x,corresp,model0);
    cs = ransac.eval.calc_cs(E);
    res = struct('cs',cs);
    [model_list(k),lo_res] = ...
        ransac.lo.fit(x,corresp,model0,res,Gsamp,Gapp);
end
