function [loss,E] = calc_loss(x,xp,cspond,cs,Gm,q,cc,H,Rtij,reprojT)
E = ones(1,size(cspond,2))*reprojT;
Einl = calc_cost(x,xp,cspond(:,cs),Gm(cs),q,cc,H,Rtij);
E(cs) = sum(Einl.^2);
E(E > reprojT) = reprojT;
loss = sum(E);