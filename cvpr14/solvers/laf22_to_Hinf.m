function l = laf22_to_Hinf(x,G)
G = findgroups(G);
W = RP2.calc_whitening_xform(x(:,~isnan(G)));
xw = blkdiag(W,W,W)*x;
[mu,sc] = ...
    cmp_splitapply(@(x) ...
                   (deal({(x(1:2,:)+x(4:5,:)+x(7:8,:))/3}, ...
                         {1./nthroot(LAF.calc_scale(x),3)})),xw,G);
l = laf2x2_to_Hinf_internal(mu,sc);
l = l'*W;

function l = laf2x2_to_Hinf_internal(aX,arsc)
if ~iscell(aX)
    aX = {aX};
    arsc = {arsc};
end

len = length(aX);
Z = [];
R = [];

for i = 1:len
    X = aX{i};
    rsc = arsc{i};
    z = [rsc .* X(1,:); rsc .* X(2,:)];
    z(len+2, :) = 0;
    z(i+2,:) = -ones(1, size(X,2));
    Z = [Z; z'];
    R = [R; rsc(:)];
end

hs = pinv(Z) * -R;
l = [hs 1]';