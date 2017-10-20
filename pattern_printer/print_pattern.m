function [xp,inlGs,inlGm] = print_pattern(model)
[Xp,inl] = sfm(model.X, ...
               model.Gs, ...
               model.Rti);
Hinv = inv(model.H);
xp = LAF.renormI(blkdiag(Hinv,Hinv,Hinv)*Xp);
inlGs = model.Gs(inl);
inlGm = model.Gm(inl);
