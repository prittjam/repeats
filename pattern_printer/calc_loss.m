function [loss,E,cs] = calc_loss(x,xp,cspond,cs0,Gm,q,cc,H,Rtij,reprojT)
if nargin < 8
    reprojT = inf
end
E = ones(1,size(cspond,2))*reprojT;
E(cs0) = sum(calc_cost(x,xp,cspond(:,cs0),Gm(cs0),q,cc,H,Rtij).^2);

cs = E < reprojT;
E(~cs) = reprojT;
loss = sum(E);