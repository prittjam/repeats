function desc = desc_find(desc_defs,dr_representation,desc_representation)
for k = 1:numel(dr_representation)
    idx = find(strcmp({desc_defs(:).output},desc_representation));
    idx2 = find(strcmp({desc_defs(idx).input},dr_representation));
    desc(k) = desc_defs(idx(idx2));
end