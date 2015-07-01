function res = extract(cfg_list,img)
syscfg = DR.syscfg();
gens = syscfg.get_gens(cfg_list);
names = arrayfun(@(x) class(x),gens,'UniformOutput',false);
[uname,ia,ic] = unique(names);

ugens = gens(ia);

cfg_list = cfg_list(:,1);
res = cell(1,numel(cfg_list));
for k = 1:numel(uname)
    cfgs = cfg_list(find(ic == k));
    res(find(ic == k)) = ugens(k).extract_features(img,cfgs);
end