function upg_ids = dr_get_upgrade_ids(dr_defs,dr)
drids = dr_get_drids(dr_defs,dr);
upg_ids = zeros(size(dr));

for k = 1:numel(upg_ids)
    upg = dr_get_upgrades(dr_defs,dr);
    upg_ids = cellfun(@(c) find(c), ...
                      cellfun(@(a) cellfun(@(b) strcmp(b{1},dr(k).upgrade),a), ...
                              upg,'UniformOutput',false));
end