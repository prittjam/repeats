function final_representations = dr_get_final_representations(dr_defs,dr)
final_representations = cell(1,numel(dr));
if nargin < 2
    [dr_defs(drids).representation];
else
    upgrades = dr_get_selected_upgrades(dr_defs,dr);
    no_upgrades = cellfun(@isempty,upgrades);
    has_upgrades = ~no_upgrades;
    representations = dr_get_representations(dr_defs,dr(no_upgrades));
    final_representaitons{find(no_upgrades)} = representations;
    final_representations(find(has_upgrades)) = cellfun(@(c) c{3},upgrades,'UniformOutput',false);
end