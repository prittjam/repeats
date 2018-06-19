function dr = unflatten(fdr)
str = fieldnames(dr);

for k = str'
    fdr.(k{:}) = [dr(:).(k{:})];
end

fdr.num_dr = size(fdr.desc,2);