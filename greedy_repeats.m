function [res,stats] = greedy_repeats(dr,cc,varargin)
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

[U,t,M.G_i] = section(u,G_app,M,Hinf);
u2 = u;
is_converged = false;

%while ~is_converged
    %    ind = ceil(rand(1,500)*height(M));
[opt_res,stats] = refine_motions(u,Hinf,M,U,t,meanRt',q,cc);
%    ui = unique(M{:,{'i','G_app','G_t'}},'rows');
%    %    u2(:,ui(:,1)) = LAF.translateU(:,ui(:,2))+
%    M.G_m = msplitapply(@(i,j,Rt) segment_motions(u,Hinf,i,j,Rt), ...
%                        M(:,{'i','j','Rt'}), ...
%                        findgroups(M.MotionModel));
%end

%PT.draw_groups(gca,PT.to_homogeneous(M.Rt'),M.G_m');
%hold on;
%plot(meanRt(:,1),meanRt(:,2),'r*');
%hold off;

res = opt_res;
res.M = M;

%res = struct('Hinf',Hinf, ...
%             'q', q, ...
%             'G', G_app.*cs);
