function G = group_desc(dr,varargin)
N = numel(dr);
G = zeros(1,N);
desc_cutoff = 200;
[T,idx] =  ...
    cmp_splitapply(@(x,y) ...
                   deal({clusterdata(single([x(:).desc]'), ...
                                     'linkage','complete', ...
                                     'criterion','distance', ...
                                     'cutoff',desc_cutoff)},{y}), ... 
                   dr,1:numel(dr),[dr(:).drid]);

maxT = max(G);
for k = 1:numel(T)
    G(idx{k}) = T{k}+maxT;
    maxT = max(G);
end

freq = hist(G,1:max(G));
[~,idxb] = ismember(find(freq == 1),G);
G(idxb) = nan;

G = findgroups(G);