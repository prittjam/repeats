function [] = draw3d_lafs(ax1,scene_geom)
X = reshape(scene_geom(1:3:end),3,[]);
Y = reshape(scene_geom(2:3:end),3,[]);
Z = reshape(scene_geom(3:3:end),3,[]);

axes(ax1);
hold on;
plot3(X,Y,Z);
hold off;