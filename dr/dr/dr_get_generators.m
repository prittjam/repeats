function gens = dr_get_generators(dr_defs,dr)
drids = dr_get_drids(dr_defs,dr);
gens = {dr_defs(drids).generator};

kkk = 3;