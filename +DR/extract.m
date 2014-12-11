function res = extract(feat_cfg_list,img)
syscfg = DR.syscfg();
gens = syscfg.get_gens(feat_cfg_list);
names = arrayfun(@(x) class(x),gens,'UniformOutput',false);
[uname,ia,ic] = unique(names);

ugens = gens(ia);

res = cell(1,numel(feat_cfg_list));
for k = 1:numel(uname)
    cfgs = feat_cfg_list(find(ic == k));
    res(find(ic == k)) = ugens(k).extract_features(img,cfgs);
end