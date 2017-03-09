function [res,stats] = refine_model(u,u_corr,cc,model0)
rho = 'geman_mcclure';
mle_impl = MleImpl(u,u_corr,cc,model0);
[res,stats] = mle_impl.fit('rho',rho);

G0 = label_outliers(stats.err0);
res0.G = G0;
res0.u_corr = u_corr;

G = label_outliers(stats.err);

u_corr = u_corr(logical(G),:);
mle_impl = MleImpl(u,u_corr,cc,res);
rho = 'l2';
[res,stats] = mle_impl.fit('rho',rho);


res.rd_div = struct('q',res.q, 'cc', cc);
res.u_corr = u_corr;
res.G = G;
rmfield(res,'q');
