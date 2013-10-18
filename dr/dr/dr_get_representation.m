function representations = dr_get_representation(dr_defs,dr)
if nargin < 2
    [dr_defs(drids).representation];
else
    upgrades = dr_get_upgrades(dr);
    
    drids = dr_get_drids(dr_defs,dr);
    representations = [dr_defs(drids).representation];
end