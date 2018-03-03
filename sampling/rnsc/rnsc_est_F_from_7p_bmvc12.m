function varargout = rnsc_est_F_from_7p_bmvc12(u,sigma,confidence)
N = size(u,2);

cfg.tsq = 3.84*sigma^2;
cfg.lo.tsq = cfg.tsq;

tic;
[Ft,inl,stats] = ransacF(u,cfg.tsq);
res.time_elapsed = toc;

res.solver = '\sevenpt';
res.tcCount = N;
res.model = Ft';

res.weights = zeros(1,N);
res.weights(inl) = 1;
res.labels = logical(res.weights);
res.inliers_found = sum(res.weights);
res.samples_drawn = stats(1);
res.loCount = stats(2);
res.rejCount = stats(3);

if res.loCount > 0
    res.from_lo = true;
else
    res.from_lo = false;
end

varargout = { res };

if nargout == 2
    varargout = cat(2,varargout,cfg);
end