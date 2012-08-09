function [ic,clust_ind,n] = laf_find_duplicates(u,cutoff,n)
    abc = [1 2 4 5 7 8];
    T = laf_agglom_clust(u(abc,:)',cutoff);
    h = hist(T,1:max(T));
    ih = find(h < n);
    [S,m] = setdiff(T,ih);
    n = numel(S);
    ia = find(ismember(T,S));
    T = T(ia);
    [TT,ib] = sort(T);
    ic = ia(ib);
    clust_ind = cell2mat(SplitVec(TT, 'equal', 'blockid'));
%    T(ib) = [col_ind{:}];

function d2 = maxdist(XI,XJ)
d0 = bsxfun(@minus,XI,XJ).^2;
d2 = max([sqrt([sum(d0(:,1:2),2) sum(d0(:,3:4),2) sum(d0(:,5: ...
                                                  6),2)])],[],2);

function [T] = laf_agglom_clust(X,cutoff)
%    Y = pdist(X,'euclidean');
    d = pdist(X,@maxdist);
    Z = linkage(d,'complete');
    T = cluster(Z,'cutoff',cutoff,'criterion','distance');