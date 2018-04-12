function G = group_desc_app(dr,varargin)
cfg.desc_cutoff = 150;
cfg.desc_linkage = 'single';

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

N = numel(dr);

unames = categories([dr(:).uname]);
is_reflected = cellfun(@(u) numel(strfind(u,'ReflectImg:')),unames);
dr_str = cellfun(@(u) strrep(u,'ReflectImg:',''),unames, ...
                 'UniformOutput',false);
Guname = findgroups([dr.uname]);
uGsdr = conncomp(graph(squareform(pdist(dr_str,@strcmp)) > 0));
Gsdr = uGsdr(Guname);

[T,idx] =  ...
    splitapply(@(x,y) ...
               deal({clusterdata(single([x(:).desc]'), ...
                                 'linkage',cfg.desc_linkage, ...
                                 'criterion','distance', ...
                                 'cutoff',cfg.desc_cutoff)},{y}), ... 
               dr,1:numel(dr),findgroups(Gsdr));

G = zeros(size(Gsdr));
maxT = max(G);
for k = 1:numel(T)
    G(idx{k}) = T{k}+maxT;
    maxT = max(G);
end

freq = hist(G,1:max(G));
[~,idxb] = ismember(find(freq == 1),G);
G(idxb) = nan;

G = reshape(findgroups(G),1,[]);
