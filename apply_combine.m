function res = apply_combine(split_res,idx,G)
split_res = [split_res{:}];
res = nan(1,numel(G));
res([idx{:}]) = split_res;
