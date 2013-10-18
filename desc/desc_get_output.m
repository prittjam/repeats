function output = desc_get_output(desc_defs,desc)
Names = desc_get_names(desc_defs);
descids = [];
for k = 1:numel(desc)
  id = find(strcmp(Names, desc(k).name));
  descids = [descids id];
end

output = {desc_defs(descids).output};
