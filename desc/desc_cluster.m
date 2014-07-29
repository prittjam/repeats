function [s,num_clusters] = desc_cluster(clust_cfg,dr)
N = size(dr.xdesc,2);
udrc = unique(dr.class);
k = numel(udrc);
c3 = zeros(1,size(dr.xdesc,2));

for i = 1:k
    ia = find((dr.class == udrc(i)) & dr.s(end,:));
    n = numel(ia);
    if n > 1
        d0 = pdist(double(dr.xdesc(:,ia)'),'euclidean');
        Z = linkage(d0,'complete');
        %        Z = linkage(d0,'single');
        c2 = cluster(Z,'cutoff',clust_cfg.cutoff,'criterion','distance');
        c3(ia) = c2+max(c3);
    end
end

h = hist(c3(find(c3>0)),1:max(c3));
m = sum(h >= clust_cfg.min_cardinality);
s = sparse([],[],false,m,N);
[~,ind] = sort(h,'descend');
for ii = 1:m
    ib = find(c3 == ind(ii));
    s(ii,ib) = true;
end
num_clusters = size(s,1);