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
is_converged = false;
%while ~is_converged
q = cfg.q0;

G_inl = findgroups(G_app.*ransac_res.cs);

for k = 1:1
    v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);
    M = est_motions(v,G_inl);
    G_m = findgroups(M.MotionModel);
    [tmp,ind] = cmp_splitapply(@segment_motions2, ...
                               M(:,{'i','j','Rt'}), ...
                               1:numel(G_m),G_m);
    G_r = tmp(ind);
    
    %    [u_corr,U,t_i,Rt] = segment_motions(v,findgroups(G_app.*cs),Hinf);
    figure;
    draw_motion_segmentation(gca,u_corr);
    ind = ceil(rand(1,500)*height(u_corr));
    opt_res = refine_motions(u,Hinf,u_corr(ind,:),U,t_i,Rt,q,cc);
    is_converged = true;
    Hinf = opt_res.Hinf;
    q = opt_res.q;
end

res = struct('Hinf',Hinf, ...
             'q', q, ...
             'G', G_app.*cs);
