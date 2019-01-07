%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [rt,is_inverted] = do_procrustes(x,rtree,Gm)

keyboard;
Gm = rtree.EndNodes.Ind
[Rtij,is_inverted] = unique_ro(Rtij0);
rt = cmp_splitapply(@(u) fit_motion_impl(u),Rtij,Gm);

function v = fit_motion_impl(u)
v = [atan2(mean(sin(u(1,:))), mean(cos(u(1,:)))); ...
     mean(u(2:3,:),2); ...
     u(4,1)];

if ~(all(u(4,:) == u(4,1)))
    keyboard;
end
    
assert(all(u(4,:) == u(4,1)),'reflections are mixed');
