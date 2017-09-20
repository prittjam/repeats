function [model_list,stats_list] = greedy_repeats(dr,varargin)
cfg.motion_model = 't';
cfg.num_planes = 1;
cfg.img = [];
cfg.cc = [];

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

corresp = cmp_splitapply(@(u) { VChooseK(u,2)' }, ...
                         1:numel(Gapp),[dr(:).Gapp]);
corresp = [ corresp{:} ];
ransac = make_ransac(dr,corresp,cc,motion_model);

for k = 1:cfg.num_planes
    [res(k),stats(k)] = ransac.fit(dr,corresp);
end
