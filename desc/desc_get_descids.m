function descids = desc_get_descids(desc_defs,desc)
descids = [];

Names = desc_get_names(desc_defs);

for k = 1:numel(desc)
  id = find(strcmp(Names, desc(k).name));
  descids = [descids id];
end