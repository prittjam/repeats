function representations = dr_get_representations(dr_defs,dr)
if nargin < 2
    [dr_defs(drids).representation];
else
    drids = dr_get_drids(dr_defs,dr);
    representations = [dr_defs(drids).representation];
end