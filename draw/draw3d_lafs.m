function [] = draw3d_lafs(ax1,X)
Xn = renormI(X);
X = reshape(Xn(1:4:end),3,[]);
Y = reshape(Xn(2:4:end),3,[]);
Z = reshape(Xn(3:4:end),3,[]);

axes(ax1);

hold on;
plot3(X,Y,Z);
hold off;

iii =3 ;