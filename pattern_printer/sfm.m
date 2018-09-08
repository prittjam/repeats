%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [Xp,inl] = sfm(X,Gs,Rti)
inl = find(~isnan(Gs));
inlGs = reshape(Gs(inl),1,[]);
Y = X(:,inlGs);
Rti = [Rti(inl,:)]';
Xp = LAF.apply_rigid_xforms(Y,Rti);
