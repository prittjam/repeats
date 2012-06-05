function dr = scene_rm_empty_dr(dr);
for i = numel(dr):-1:1
    if isempty(dr(i).geom)
        dr(i) = [];
    end
end