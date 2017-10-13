function sc = calc_scale(lafs)
%A = [1:3];
%B = [4:6];
%C = [7:9];
%
%sc = ar(lafs(A,:),lafs(B,:)) + ar(lafs(B,:),lafs(C,:)) + ar(lafs(C, ...
%                                                  :),lafs(A,:));
%sc = 2*sc;
%%sc = abs(sc);
%
%function a = ar(A,B)
%  a = (A(1,:) - B(1,:)) .* (A(2,:) + B(2,:)) /2; 
%
lafsA1 = lafs(1,:);
lafsA2 = lafs(2,:);
lafsB1 = lafs(4,:);
lafsB2 = lafs(5,:);
lafsC1 = lafs(7,:);
lafsC2 = lafs(8,:);

sc = abs((lafsA1-lafsB1).*(lafsA2+lafsB2) + ...
         (lafsB1-lafsC1).*(lafsB2+lafsC2) + ...
         (lafsC1-lafsA1).*(lafsC2+lafsA2))/2;
