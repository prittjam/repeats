function res = greedy_repeats(dr,cc,varargin)
cfg.q0 = 0.0;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

G_app = group_desc(dr);
sampler = GrSampler(G_app);
eval = GrEval();
model = RANSAC.WRAP.laf1x3_to_HaHp();
lo = GrLo();
ransac = RANSAC.Ransac(model,sampler,eval,'lo',lo);

[Hinf,ransac_res,stats] = ransac.fit(dr,G_app);

u = [dr(:).u];
q = cfg.q0;

G_inl = findgroups(G_app.*ransac_res.cs);

v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);
M = resection(v,G_inl);

M.G_m = msplitapply(@(i,j,Rt) segment_motions(u,Hinf,i,j,Rt), ...
                    M(:,{'i','j','Rt'}), ...
                    findgroups(M.MotionModel));
M.G_app = G_app(M.i)';

meanRt = cmp_splitapply(@mean,M.Rt,findgroups(M.G_m));
%PT.draw_groups(gca,PT.to_homogeneous(M.Rt'),M.G_r');
%hold on;plot(meanRt(:,1),meanRt(:,2),'r*');hold off;
%
[U,M.G_t,t_i] = section(u,G_app,M,Hinf);

ind = ceil(rand(1,500)*height(M));
opt_res = refine_motions(u,Hinf,M(ind,:),U,t_i,meanRt',q,cc);

res = struct('Hinf',Hinf, ...
             'q', q, ...
             'G', G_app.*cs);
