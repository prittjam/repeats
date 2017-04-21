function [Gapp,Gr] = group_desc(dr,varargin)
cfg.desc_cutoff = 150;
cfg.desc_linkage = 'single';
cfg.group_reflections = true;

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
    cmp_splitapply(@(x,y) ...
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

Gapp = reshape(findgroups(G),1,[]);
Gr = reshape(is_reflected(findgroups([dr.uname])),1,[]);

if ~cfg.group_reflections
    Gr_tmp = Gr;
    Gr_tmp(find(Gr_tmp == 0)) = -1;
    Gapp = findgroups(Gapp.*Gr_tmp);
    freq = hist(Gapp,1:max(Gapp));
    bad_labels = find(freq < 2);
    [~,ind] = ismember(bad_labels,Gapp);
    Gapp(ind) = nan;
    Gapp = findgroups(Gapp);
end
%G = msplitapply(@(dr,G) rm_duplicates([dr(:).u],G),dr,G0,G0);

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
