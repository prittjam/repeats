function [] = draw(ax,P)
s = 10;
[K R c] = CAM.P_to_KRc(P);
sR = s*R;
hold on;
plot3(c(1),c(2),c(3),'go');
for k = 1:3
    line([c(1) c(1)+sR(1,k)], ...
         [c(2) c(2)+sR(2,k)], ...
         [c(3) c(3)+sR(3,k)], ...
         'Color','r');
end
hold off;
