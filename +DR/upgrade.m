function res = upgrade(upg_cfg_list,img,feats)
syscfg = dr.syscfg();
upgrades = syscfg.get_upgrades(upg_cfg_list);
names = arrayfun(@(x) class(x),upgrades,'UniformOutput',false);
[uname,ia,ic] = unique(names);

uupgrades = upgrades(ia);

res = cell(1,numel(upg_cfg_list));
for k = 1:numel(uname)
    upg_cfgs = upg_cfg_list(find(ic == k));
    res(find(ic == k)) = uupgrades(k).upgrade_features(img,feats,upg_cfgs);
end