function [l,N] = hg_2x2laf_to_linf(aX,arsc)
% scale2H_multi
if ~iscell(aX)
    aX = {aX};
    rsc = {arsc};
end

ALLX = [aX{:}];
ALLX = ALLX(1:2,:);

tx = mean(ALLX(1,:));
ty = mean(ALLX(2,:));
ALLX(1,:) = ALLX(1,:) - tx;
ALLX(2,:) = ALLX(2,:) - ty;
dsc = max(abs(ALLX(:)));

A = eye(3);
A([1,2],3) = -[tx ty] / dsc;
A(1,1) = 1 / dsc;
A(2,2) = 1 / dsc;


len = length(aX);
Z = [];
R = [];

for i = 1:len
    X = aX{i};
    rsc = arsc{i};
    X(1,:) = (X(1,:) - tx) / dsc;
    X(2,:) = (X(2,:) - ty) / dsc;

    z = [rsc .* X(1,:); rsc .* X(2,:)];
    z(len+2, :) = 0;
    z(i+2,:) = -ones(1, size(X,2));

    Z = [Z; z'];
    R = [R; rsc(:)];
end


hs = pinv(Z) * -R;
sc_norm = 1;
l = [hs(1);hs(2);1];
N = [A(1,1) A(1,3) A(2,3) sc_norm]';