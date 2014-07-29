function selupgs = dr_get_selected_upgrades(dr_defs,dr,upgrades)
drids = dr_get_drids(dr_defs,dr);
upg_ids = zeros(size(dr));

for k = 1:numel(upg_ids)
    upg = dr_get_upgrades(dr_defs,dr);
    upg_ids = cellfun(@(c) find(c), ...
                      cellfun(@(a) cellfun(@(b) strcmp(b{1},upgrades(k).name),a), ...
                              upg,'UniformOutput',false));
    for k = 1:numel(upg)
        selupgs{k} = upg{k}{upg_ids(k)};
    end
end