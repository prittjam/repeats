%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function Gr = get_reflections(dr,G)
Gr = msplitapply(@(dr,G) has_reflections(dr,G),dr,G,G);

function Gr = has_reflections(dr,G)
if numel(unique([dr(:).reflected])) == 2
    Gr = G;
else
    Gr = nan(1,numel(G));
end
