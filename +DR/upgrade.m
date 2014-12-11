function res = upgrade(upg_cfg_list,img,feats)
syscfg = DR.syscfg();
upgrades = syscfg.get_upgrades(upg_cfg_list);
names = arrayfun(@(x) class(x),upgrades,'UniformOutput',false);
[uname,ia,ic] = unique(names);

uupgrades = upgrades(ia);

res = cell(1,numel(upg_cfg_list));
for k = 1:numel(uname)
    same_upgs = find(ic == k);
    res(same_upgs) = uupgrades(k).upgrade_features(img, ...
                                                   feats(same_upgs), ...
                                                   upg_cfg_list(same_upgs));
end