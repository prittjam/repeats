function [model_list,stats_list] = greedy_repeats(dr,cc,motion_model,num_planes)
if nargin < 4
    num_planes = 1;
end

corresp = cmp_splitapply(@(u) { VChooseK(u,2)' }, ...
                         1:numel(dr),[dr(:).Gapp]);
corresp = [ corresp{:} ];

[ransac,eval,lo] = make_ransac(dr,cc,motion_model,corresp);

for k = 1:num_planes
    [model0,~,~,stats_list(k)] = ransac.fit(dr,corresp);
    [loss,E] = eval.calc_loss(dr,corresp,model0);
    cs = eval.calc_cs(E);
    res = struct('cs',cs);
    [model_list(k),lo_res] = lo.fit(dr,corresp,res);
end

function [ransac,eval,lo] = make_ransac(dr,cc,motion_model,corresp)
switch motion_model
  case 't'
    solver = RANSAC.WRAP.laf2x2_to_HaHp();
  case 'Rt'
    solver = RANSAC.WRAP.laf2x2_to_HaHp();
end

sampler = GrSampler(dr,corresp,2);
eval = GrEval();
lo = GrLo(cc,'motion_model',motion_model);
ransac = RANSAC.Ransac(solver,sampler,eval,'lo',lo);
