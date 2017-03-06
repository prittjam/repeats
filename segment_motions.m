function [G_rt,Rt] = segment_motions(u,M,Hinf,varargin)
cfg.vq_distortion = 5;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);


N = height(M);
[aa,bb] = meshgrid(1:N,1:N);
v_mu = v(4:6,M.i(aa(:)));

theta = M.theta(bb,:)';
tij = M.tij(bb,:)';

Hinv = inv(Hinf);
x = PT.to_euclidean(Hinv*(PT.apply_rigid_xforms(v_mu,theta,tij)));    
y = u(4:5,M.j(aa(:)));
d = sqrt(sum((y-x).^2));
ind = sub2ind([N N],aa,bb);

R = inf(N,N);
R(ind) = d;

P = prefMat(R,cfg.vq_distortion,1);
G = tlnk(P);
G = outlier_rejection_card(G,2);
G(find(G == 0)) = nan;
G_rt = findgroups(G);

theta_uw = msplitapply(@(theta)  unwrap(theta), M.theta, G_rt);
M{~isnan(G_rt),'theta'} = theta_uw(~isnan(G_rt));
meanRt = cmp_splitapply(@mean,M{:,{'theta','tij'}},G_rt)';
Rt = struct('theta', mat2cell(meanRt(1,:),1,ones(1,size(meanRt,2))), ...
            't', mat2cell(meanRt(2:3,:),2,ones(1,size(meanRt,2))));
G_rt = reshape(G_rt,[],1);
