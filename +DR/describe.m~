function res = describe(desc_cfg_list,img,feats)
syscfg = DR.syscfg();
descriptor_list = syscfg.get_descriptors(desc_cfg_list);
names = arrayfun(@(x) class(x),descriptor_list,'UniformOutput',false);
[uname,ia,ic] = unique(names);

udescribes = descriptor_list(ia);

res = cell(1,numel(desc_cfg_list));
for k = 1:numel(uname)
    upg_cfgs = desc_cfg_list(find(ic == k));
    desc_cfgs = desc_cfg_list(find(ic == k));
    res(find(ic == k)) = udescribes(k).describe_features(img,feats,desc_cfgs);
end