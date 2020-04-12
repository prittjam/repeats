function G = label_vp_to_circ(c,varargin)
cfg = struct('outlierT', 1e5, ...
             'vqT', 400, ...
             'cutoff', 0.5);

% not implemented yet
%             'topN', 5, ...
%             'min_support', 3, ...

cfg = cmp_argparse(cfg,varargin{:});

x0 = [c(1:2,:); ...
      ones(1,size(c,2))];
is_xgood = (x0(1,:) < cfg.outlierT) & (x0(1,:) > -cfg.outlierT);
is_ygood = (x0(2,:) < cfg.outlierT) & (x0(2,:) > -cfg.outlierT);
is_good = find(is_xgood & is_ygood);
x = [x0(:,is_good)];

cspond = nchoosek(1:size(x,2),2);

l = cross(x(:,cspond(:,1)),x(:,cspond(:,2)));
l = l./sqrt(sum(l(1:2,:).^2));

m = size(x,2);
n = size(l,2);

d2 = reshape(abs(x'*l),m,n);
d2(d2 < 10*eps) = 2*cfg.vqT;
K = sparse(double(d2 < cfg.vqT));

is_valid_ii = find(any(K,2));
is_valid_jj = find(any(K,1));
K = K(is_valid_ii,is_valid_jj);
w0 = lp_vq(K);
w = rm_duplicate_motions(K,w0);
code_ind = find(w>0);

Kcodes = K(:,w>0);
T = clusterdata(full(Kcodes'), ...
                'linkage','complete', ...
                'criterion','distance', ...
                'cutoff',cfg.cutoff, ...
                'Distance', 'jaccard');
G = nan(1,size(c,2));

for k = 1:size(Kcodes,2)
    ind = find(Kcodes(:,k));
    G(is_good(is_valid_ii(ind))) = T(k);
end

%idx = find(~isnan(G));
%freq = hist(G,1:max(G));
%badG = find(freq < cfg.min_support);
%invalid = ismember(G,badG);
%G(invalid) = nan;
%G = findgroups(G);
%
%freq = hist(G,1:max(G));
%[~,bestG] = sort(freq,'descend');
%bestG = bestG(1:cfg.topN);
%invalid = ~ismember(G,bestG)
%G(invalid) = nan;
G = findgroups(G);