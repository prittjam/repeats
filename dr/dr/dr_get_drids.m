function DRids = dr_get_drids(dr_defs,dr)
DRids = [];
Names = dr_get_names(dr_defs);

for k = 1:numel(dr)
  id = find(strcmp(Names, dr(k).name));
  DRids = [DRids id];
end