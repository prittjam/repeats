function [res,stats] = greedy_repeats(dr,cc,varargin)
cfg.q0 = 0.0;
cfg.motion_model = 'laf2xN_to_RtxN';

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

G_app = group_desc(dr);
sampler = GrSampler(G_app);
eval = GrEval('motion_model',cfg.motion_model);
model = RANSAC.WRAP.laf1x3_to_HaHp();
lo = GrLo();
ransac = RANSAC.Ransac(model,sampler,eval,'lo',lo);

[Hinf,ransac_res,stats] = ransac.fit(dr,G_app);

u = [dr(:).u];
q = cfg.q0;

G_inl = findgroups(G_app.*ransac_res.cs);

v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);

M = resection(v,G_inl,cfg.motion_model);

M.G_m = msplitapply(@(i,j,theta,t) segment_motions(u,Hinf,i,j,theta,t), ...
                    M(:,{'i','j','theta','t'}),findgroups(M.MotionModel));
M.G_app = G_app(M.i)';

meanRt = cmp_splitapply(@mean,M{:,{'theta','t'}},findgroups(M.G_m));
tij = meanRt(:,2:3)';
theta = meanRt(:,1)';

[U,t,M.G_i] = section(u,G_app,M,Hinf);
u2 = u;
is_converged = false;

%while ~is_converged
    %    ind = ceil(rand(1,500)*height(M));
[opt_res,stats] = refine_motions(u,Hinf,M,U,t,tij,theta,q,cc);
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
