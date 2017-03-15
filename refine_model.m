function [l2_model,l2_stats,u_corr] = refine_model(u,u_corr0,cc,model0)
[u_corr,model] = get_valid_motions(u_corr0,model0);
mle_impl = MleImpl(u,u_corr,cc,model);
[robust_model,robust_stats] = mle_impl.fit('rho','geman_mcclure');

G = label_inliers(robust_stats.l2);
[robust_u_corr,robust_model] = get_valid_motions(u_corr(G,:),robust_model);


mle_impl = MleImpl(u,robust_u_corr,cc,robust_model);
[l2_model,l2_stats] = mle_impl.fit('rho','l2');
