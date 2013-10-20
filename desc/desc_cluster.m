function [s,m] = desc_cluster(clust_cfg,dr)
N = size(dr.desc,2);
udrc = unique(dr.class);
k = numel(udrc);
c3 = zeros(1,size(dr.desc,2));

for i = 1:k
    ia = find((dr.class == udrc(i)) & dr.s(end,:));
    n = numel(ia);
    if n > 1
        d0 = pdist(double(dr.desc(:,ia)'),'euclidean');
        Z = linkage(d0,'complete');
        c2 = cluster(Z,'cutoff',clust_cfg.thresh,'criterion','distance');
        c3(ia) = c2+max(c3);
    end
end

h = hist(c3(find(c3>0)),1:max(c3));
m = sum(h >= clust_cfg.minsize);
s = sparse([],[],false,m,N);
[~,ind] = sort(h,'descend');
for ii = 1:m
    ib = find(c3 == ind(ii));
    s(ii,ib) = true;
end

[nums,ind] = sort(sum(s,2),'descend');
s = s(ind(nums >= clust_cfg.minsize),:);
m = size(s,1);