function [U,Rt,G_rti] = section(u,M,Hinf)
v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);
w = LAF.translate(v(:,M.i),-v(4:5,M.i));
U = cmp_splitapply(@(w) w(:,1),w,M.G_u');
[G_rti,uG_rti] = findgroups(M.i');
G_rti = reshape(G_rti,[],1);
Rt = cmp_splitapply(@(G_u,G_i) { HG.laf2xN_to_RtxN([U(:,G_u(1));v(:,G_i(1))]) }, ...
                    M.G_u,M.i,G_rti);
Rt = [ Rt{:} ];
