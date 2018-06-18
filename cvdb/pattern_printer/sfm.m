function [Xp,inl] = sfm(X,Gs,Rti)
inl = find(~isnan(Gs));
inlGs = reshape(Gs(inl),1,[]);
Y = X(:,inlGs);
Rti = [Rti(inl,:)]';
Xp = LAF.apply_rigid_xforms(Y,Rti);
