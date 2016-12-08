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

G_r = reshape(msplitapply(@(i,j,Rt) segment_motions(u,Hinf,i,j,Rt), ...
                          M(:,{'i','j','Rt'}), ...
                          findgroups(M.MotionModel)),1,[]);
PT.draw_groups(gca,PT.to_homogeneous(M.Rt'),G_r);
[U,t_i] = section(u,M,Hinf);

ind = ceil(rand(1,500)*height(u_corr));
opt_res = refine_motions(u,Hinf,u_corr(ind,:),U,t_i,Rt,q,cc);

%    is_converged = true;<
%    Hinf = opt_res.Hinf;
%    q = opt_res.q;
%

res = struct('Hinf',Hinf, ...
             'q', q, ...
             'G', G_app.*cs);
