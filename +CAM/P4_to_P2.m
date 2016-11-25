function [P0 opt_P] = P4_to_P2(u,P1,P2,P3,P4)
PP = zeros(3,4,4);

PP(:,:,1) = P1;
PP(:,:,2) = P2;
PP(:,:,3) = P3;
PP(:,:,4) = P4;

n = size(u,2);
s = false(1,n);
%if n < 15
s = true(1,n);
%else
%    s(ceil(n*rand(1,15))) = true;
%end

P0 = [eye(3,3) zeros(3,1)];
optz = -inf;
for i = 1:4
    [X,s2] = pt1x2_to_X(u,s,P0,PP(:,:,i));
    nz = sum(s2);
    if nz > optz
        optz = nz;
        opt_P = PP(:,:,i);
    end
end