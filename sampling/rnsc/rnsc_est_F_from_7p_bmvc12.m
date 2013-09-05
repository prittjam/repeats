function varargout = rnsc_est_F_from_7p_bmvc12(u,s,sigma,confidence)

cfg.tsq = 3.84*sigma^2;
cfg.lo.tsq = cfg.tsq;

tic;
[Ft,inl,stats] = ransacF(u(:,s),cfg.tsq);
res.time_elapsed = toc;

res.solver = 'F-7p-BMVC12';
res.tcCount = sum(s);
res.model = Ft';

res.weights = zeros(1,numel(s));

ind = find(s);
res.weights(ind(inl)) = 1;
res.labels = logical(res.weights);

res.inliers_found = sum(res.weights);
res.samples_drawn = stats(1);
res.loCount = stats(2);
res.rejCount = stats(3);
res.from_lo = true;

varargout = { res };

if nargout == 2
    varargout = cat(2,varargout,cfg);
end