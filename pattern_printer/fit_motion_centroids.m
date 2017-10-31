function [rt,is_inverted] = fit_motion_centroids(Gm,Rtij0)
Gm = reshape(Gm,1,[]);
[Rtij,is_inverted] = unique_ro(Rtij0);
rt = cmp_splitapply(@(u) fit_motion_impl(u),Rtij,Gm);

function v = fit_motion_impl(u)
v = [atan2(mean(sin(u(1,:))), mean(cos(u(1,:)))); ...
     mean(u(2:3,:),2); ...
     u(4,1)];

assert(all(u(4,:) == u(4,1)),'reflections are mixed');
