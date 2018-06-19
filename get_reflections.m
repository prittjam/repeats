function Gr = get_reflections(dr,G)
Gr = msplitapply(@(dr,G) has_reflections(dr,G),dr,G,G);

function Gr = has_reflections(dr,G)
if numel(unique([dr(:).reflected])) == 2
    Gr = G;
else
    Gr = nan(1,numel(G));
end
