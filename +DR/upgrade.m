function res = upgrade(cfg_list,img,feats)
syscfg = DR.Syscfg();
upgrades = syscfg.get_upgrades(cfg_list);
names = arrayfun(@(x) class(x),upgrades,'UniformOutput',false);
[uname,ia,ic] = unique(names);

uupgrades = upgrades(ia);

cfg_list = cfg_list(:,2);
res = cell(1,numel(cfg_list));
for k = 1:numel(uname)
    same_upgs = find(ic == k);
    res(same_upgs) = uupgrades(k).upgrade_features(img, ...
                                                   feats(same_upgs), ...
                                                   cfg_list(same_upgs));
end