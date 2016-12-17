function [U0,t,G_i] = section(u,G_app,M,Hinf)
v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);
w = LAF.translate(v,-v(4:5,:));
U0 = cmp_splitapply(@(w) w(:,1),w,G_app);

[G_i,uG_i] = findgroups(M.i');
t = v(4:5,uG_i);
G_i = G_i';
