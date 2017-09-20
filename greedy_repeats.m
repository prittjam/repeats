function [model_list,stats_list] = greedy_repeats(dr,cc,motion_model,num_planes)
if nargin < 4
    num_planes = 1;
end

switch motion_model
  case 't'
    solver = RANSAC.WRAP.laf2x2_to_HaHp();
  case 'Rt'
    solver = RANSAC.WRAP.laf2x2_to_HaHp();
end

corresp = cmp_splitapply(@(u) { VChooseK(u,2)' }, ...
                         1:numel(dr),[dr(:).Gapp]);
corresp = [ corresp{:} ];
sampler = GrSampler(dr,corresp,2);
eval = GrEval2();
lo = GrLo(cc,'motion_model',motion_model);
ransac = RANSAC.Ransac(solver,sampler,eval,'lo',lo);

for k = 1:num_planes
    [model_list(k),stats_list(k)] = ransac.fit(dr,corresp);
end
