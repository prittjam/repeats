function [l2_corresp,l2_model,l2_stats] = refine_model(u,corresp0,model0)
[corresp,model] = get_valid_motions(corresp0,model0);

mle_impl = MleImpl(u,corresp,model);
%err = mle_impl.calc_err();
[l2_model0,l2_stats] = mle_impl.fit('rho','l2');
G = label_inliers(l2_stats.l2);
[l2_corresp,l2_model] = get_valid_motions(corresp(G,:),l2_model0);

%keyboard;
%
%
%%G = label_inliers(robust_stats.l2);
%%[robust_corresp,robust_model] = get_valid_motions(corresp(G,:),robust_model);
%%
%mle_impl = MleImpl(u,robust_corresp,robust_model);
%[l2_model,l2_stats] = mle_impl.fit('rho','l2');
%
%
%%[l2_corresp,l2_model] = get_valid_motions(robust_corresp(G,:),l2_model);
%
%[robust_corresp,robust_model] = get_valid_motions(corresp(G,:),robust_model);
