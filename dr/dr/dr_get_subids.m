function subids = dr_get_subids(dr_defs,dr)
subids = [];
if nargin<2
    subids = [dr_defs.subgenid];
else
    drids = dr_get_drids(dr_defs,dr);
    subids = [dr_defs(drids).subgenid];
end