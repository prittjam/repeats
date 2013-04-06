function sc = laf_get_scale_from_3p(lafs)
A = [1:3];
B = [4:6];
C = [7:9];

sc = ar(lafs(A,:),lafs(B,:)) + ar(lafs(B,:),lafs(C,:)) + ar(lafs(C,:),lafs(A,:));
sc = abs(2*sc);
%sc = abs(sc);

function a = ar(A,B)
  a = (A(1,:) - B(1,:)) .* (A(2,:) + B(2,:)) /2; 