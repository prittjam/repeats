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

G0 = findgroups(G);
G = msplitapply(@(dr,G) rm_duplicates([dr(:).u],G),dr,G0,G0);

function G = rm_duplicates(u,G)
K = size(u,2);
d2 = pdist(u(4:5,:)','euclidean')';
ind = find(d2 < 100*eps);
if ~isempty(ind)
    [I,J] = ind2sub(size(u,2),ind);
    G([I;J]) = nan;
    num_good = sum(~isnan(G));
    if num_good == 1
        G = nan(size(G));
    end
end
