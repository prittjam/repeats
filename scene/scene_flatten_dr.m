function fdr = scene_flatten_dr(cdr)
fdr = struct;
for dr = cdr
    fn = fieldnames(dr);
    for m = 1:numel(fn)
        nm = fn{m};
        if isfield(fdr,nm)
            fdr.(nm) = cat(2,fdr.(nm),dr.(nm));
        else
            fdr.(nm) = dr.(nm);
        end
    end
end