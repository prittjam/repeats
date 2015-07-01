function res = describe(cfg_list,img,upgs)
syscfg = DR.syscfg();
descriptor_list = syscfg.get_descriptors(cfg_list);
names = arrayfun(@(x) class(x),descriptor_list,'UniformOutput',false);
[uname,ia,ic] = unique(names);

udescribes = descriptor_list(ia);

cfg_list = cfg_list(:,3);
res = cell(1,numel(cfg_list));
for k = 1:numel(uname)
    same_descs = find(ic == k);
    res(same_descs) = udescribes(k).describe_features(img,...
                                                      upgs(same_descs),...
                                                      cfg_list(same_descs));
end