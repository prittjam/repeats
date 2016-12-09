function [U,G_t,t_i] = section(u,G_app,M,Hinf)
v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);
U = cmp_splitapply(@(w)  w(:,1),v,G_app);
[G_t,uG_t] = findgroups(M.i);
t_i = v(4:5,uG_t);
