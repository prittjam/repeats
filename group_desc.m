function G = group_desc(dr,varargin)
cfg.desc_cutoff = 300;
cfg.desc_linkage = 'single';
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

N = numel(dr);
G = zeros(1,N);

[T,idx] =  ...
    cmp_splitapply(@(x,y) ...
                   deal({clusterdata(single([x(:).desc]'), ...
                                     'linkage',cfg.desc_linkage, ...
                                     'criterion','distance', ...
                                     'cutoff',cfg.desc_cutoff)},{y}), ... 
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
