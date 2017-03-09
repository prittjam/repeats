function [l2_model,l2_stats,u_corr] = refine_model(u,u_corr0,cc,model0)
rho = 'geman_mcclure';
mle_impl = MleImpl(u,u_corr0,cc,model0);
[robust_model,robust_stats] = mle_impl.fit('rho',rho);

G = label_outliers(robust_stats.err);
u_corr = u_corr0(logical(G),:);

mle_impl = MleImpl(u,u_corr,cc,robust_model);
[l2_model,l2_stats] = mle_impl.fit('rho','l2');
