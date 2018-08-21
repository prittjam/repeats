function [model_list,stats_list] = ...
    repeats(x,Gsamp,Gapp,cc,motion_model)
if nargin < 4
    num_planes = 1;
end

sigma = 1;
threshold_list = { 'extentT', log(1.05), ...
                   'vqT',  21.026*sigma^2, ...
                   'reprojT', 21.026*sigma^2 };

corresp = cmp_splitapply(@(u) { VChooseK(u,2)' }, ...
                         1:numel(dr),[dr(:).Gapp]);
corresp = [ corresp{:} ];

[ransac,eval,lo] = make_ransac(x,cc,motion_model,corresp, ...
                               threshold_list);

for k = 1:num_planes
    [model0,~,~,stats_list(k)] = ransac.fit(dr,corresp);
    [loss,E] = eval.calc_loss(dr,corresp,model0);
    cs = eval.calc_cs(E);
    res = struct('cs',cs);
    [model_list(k),lo_res] = lo.fit(dr,corresp,res, ...
                                    'MaxIterations',30);
end

function [ransac,eval,lo] = make_ransac(dr,cc,motion_model,corresp,varargin)
switch motion_model
  case 't'
    solver = SOLVER.laf2x2_to_AHinf();
  case 'Rt'
    solver = SOLVER.laf2x2_to_AHinf();
end

sampler = GrSampler(dr,corresp,2);
eval = GrEval(varargin{:});
lo = GrLo(cc,motion_model,varargin{:});
ransac = Ransac(solver,sampler,eval,'lo',lo);