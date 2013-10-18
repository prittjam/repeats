function [upg] = dr_get_upgrades(dr_defs,dr)
drids = dr_get_drids(dr_defs,dr);
upg = {dr_defs(drids).upgrades};