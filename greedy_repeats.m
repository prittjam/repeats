function [res,stats] = greedy_repeats(dr,varargin)
cfg.motion_model = 'laf2xN_to_RtxN';
cfg.rd_div = [];
cfg.img = [];
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

G_app = group_desc(dr,varargin{:});
sampler = GrSampler(G_app);
eval = GrEval('motion_model',cfg.motion_model);
model = RANSAC.WRAP.laf1x3_to_HaHp();
lo = GrLo();
ransac = RANSAC.Ransac(model,sampler,eval,'lo',lo);

[Hinf0,ransac_res,stats] = ransac.fit(dr,G_app);
u = [dr(:).u];

G_inl = findgroups(G_app.*ransac_res.cs);

if ~isempty(cfg.img)
    imshow(cfg.img);
    LAF.draw_groups(gca,u,G_inl);
end

v = LAF.renormI(blkdiag(Hinf0,Hinf0,Hinf0)*u);

keyboard;
M = resection(v,G_inl,cfg.motion_model);
M.G_app = G_app(M.i)';

%M.G_rt = msplitapply(@(i,j,theta,tij) segment_motions(u,Hinf0,i,j,theta,tij), ...
%                    M(:,{'i','j','theta','tij'}), ...
%                     findgroups(M.MotionModel));
%

M.G_rt = segment_motions(u,M,Hinf0,varargin{:});
[U0,ti0,M.G_i] = section(u,M,Hinf0);
keyboard;
mle_impl = MleImpl();
initial_guess = struct('Hinf',Hinf0,'U',U0,'ti',ti0, ...
                       'tij',tij0,'theta',theta0, ...
                       'rd_div',cfg.rd_div, ...
                       'u_corr',M);
mle_impl.set_initial_guess(u,initial_guess);

mle = Mle(mle_impl);

mle.set_initial_guess(u,M,Hinf0,U,ti,tij,theta, ...
                        'rd_div',cfg.rd_div);


%draw_reconstruction(u,M,Hinf0,M,U,ti,theta,tij);

%u2 = u;
%is_converged = false;
%%while ~is_converged
    %    ind = ceil(rand(1,500)*height(M));

[opt_res,stats] = refine_motions(u,Hinf0,M,U,ti,tij,theta,q,cc,varargin{:});
%    ui = unique(M{:,{'i','G_app','G_t'}},'rows');
%    %    u2(:,ui(:,1)) = LAF.translateU(:,ui(:,2))+
%M.G_m = msplitapply(@(i,j,Rt) segment_motions(u,Hinf0,i,j,Rt), ...
%                    M(:,{'i','j','Rt'}), ...
%                    findgroups(M.MotionModel));
%%end
opt_res.cc = cc;
res = opt_res;
res.M = M;
res.cc = cc;


function do_hist(theta)
figure;
hist(theta,[-pi:pi/50:pi]);
axis tight;
