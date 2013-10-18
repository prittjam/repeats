function [Names] = desc_get_names(desc_defs)
Names = [];
if ~isempty(desc_defs)
    Names = {desc_defs.name};
end