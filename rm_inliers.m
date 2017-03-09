function [G_app] = rm_inliers(u_corr,G_app)
inl = unique([u_corr.i u_corr.j]);
G_app(inl) = nan;
card = hist(G_app,1:max(G_app));
singletons = find(card == 1);
[~,lib] = ismember(singletons,G_app);
G_app(lib) = nan;
G_app = findgroups(G_app);
