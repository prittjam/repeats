%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [ic,clust_ind,n] = laf_find_duplicates(u,cutoff,n)
    T = laf_agglom_clust(u,cutoff);
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

function [T] = laf_agglom_clust(X,cutoff)
    d = pdist(X',@laf_maxdist);
    Z = linkage(d,'complete');
    T = cluster(Z,'cutoff',cutoff,'criterion','distance');