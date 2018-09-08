%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function G = separate_look_alikes(x,cspond,res)
N = size(x,2);
inl_cspond = cspond(:,logical(res.cs)); 
scspond = inl_cspond(1,:);
tcspond = inl_cspond(2,:);
gr = graph(scspond,tcspond,ones(1,numel(scspond)),N);
Gcomp = conncomp(gr);
freq = hist(Gcomp,1:max(Gcomp));
stons = find(freq==1);
Gcomp(find(ismember(Gcomp,stons))) = nan;
G = findgroups(Gcomp);
