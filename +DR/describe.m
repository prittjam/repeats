function res = describe(desc_cfg_list,img,upgs)
syscfg = DR.syscfg();
descriptor_list = syscfg.get_descriptors(desc_cfg_list);
names = arrayfun(@(x) class(x),descriptor_list,'UniformOutput',false);
[uname,ia,ic] = unique(names);

udescribes = descriptor_list(ia);

res = cell(1,numel(desc_cfg_list));
for k = 1:numel(uname)
    same_descs = find(ic == k);
    res(same_descs) = udescribes(k).describe_features(img,...
                                                      upgs(same_descs),...
                                                      desc_cfg_list(same_descs));
end