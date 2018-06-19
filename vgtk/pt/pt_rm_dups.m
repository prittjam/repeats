function uind = pt_rm_dups(u,tsq)
if nargin < 2
    tsq = eps;
end

m = size(u,2);
d2 = pdist(u);
ind = find(d2<tsq);
[ii,jj] = ind2sub([m,m],ind);
tmp = tril(ones(m,m),-1);
[~,jj] = find(tmp);
[~,ind2] = unique(jj(ind));
uind = ind(ind2);