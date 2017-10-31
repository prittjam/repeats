<<<<<<< HEAD
function xp = print_pattern(model)
[Xp,inl] = sfm(model_list(k).X, ...
               model_list(k).Gs, ...
               model_list(k).Rti);
Hinv = inv(model_list(k).H);
xp = LAF.renormI(blkdiag(Hinv,Hinv,Hinv)*Xp);
=======
function [xp,inlGs,inlGm] = print_pattern(model)
[Xp,inl] = sfm(model.X, ...
               model.Gs, ...
               model.Rti);
Hinv = inv(model.H);
xp = LAF.renormI(blkdiag(Hinv,Hinv,Hinv)*Xp);
inlGs = model.Gs(inl);
inlGm = model.Gm(inl);
>>>>>>> origin/origin
