function [l2_model,l2_stats,u_corr] = refine_model(u,u_corr0,cc,model0)
rho = 'geman_mcclure';

mle_impl = MleImpl(u,u_corr0,cc,model0);
[robust_model,robust_stats] = mle_impl.fit('rho',rho);

G = label_inliers(robust_stats.err);
u_corr = compress_model(u_corr0(logical(G),:),robust_model);

mle_impl = MleImpl(u,u_corr,cc,robust_model);
[l2_model,l2_stats] = mle_impl.fit('rho','l2');

function [u_corr,model] = compress_model(u_corr,robust_model)
[u_corr.G_u,uG_u] = findgroups(u_corr.G_u);
[u_corr.G_i,uG_i] = findgroups([u_corr.G_i]);
[u_corr.G_ij,uG_ij] = findgroups(u_corr.G_ij);

model.U = robust_model.U(:,uG_u);
model.Rt_i = robust_model.Rt_i(:,uG_i);
model.Rt_ij = robust_model.Rt_ij(:,uG_ij);
