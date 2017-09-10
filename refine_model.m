function [l2_model,l2_stats] = refine_model(u,corresp0,model0)
mle_impl = MleImpl(u,corresp0,model0);
[l2_model,l2_stats] = mle_impl.fit('rho','l2');
