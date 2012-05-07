function [] = draw_lafs_3d(ax1,scene_geom)
axes(ax1);
hold on;
X = reshape(scene_geom(1,:),3,[]);
Y = reshape(scene_geom(2,:),3,[]);
Z = reshape(scene_geom(3,:),3,[]);
hold of;
plot3(X,Y,Z);
