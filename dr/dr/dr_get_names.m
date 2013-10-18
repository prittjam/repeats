function [Names] = dr_get_names(dr_defs)
Names = [];
if ~isempty(dr_defs)
    Names = {dr_defs.name};
end