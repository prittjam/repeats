function dr2 = scene_rm_empty_dr_set(dr);
dr2 = scene_construct_dr();
for i = 1:numel(dr)
    if ~isempty(dr.geom)
        dr2 = cat(2,dr2,dr);
    end
end