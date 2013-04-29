function l = draw2d_epipolar_geom(ax1,ax2,u,F)
l = blkdiag(F',F)*u([4:6 1:3],:);

draw2d_lines(ax1,l(1:3,:),'Color',[0 0 0.75],'LineWidth',2);
draw2d_points(ax1,u(1:2,:));

draw2d_lines(ax2,l(4:6,:),'Color',[0 0 0.75],'LineWidth',2);
draw2d_points(ax2,u(4:5,:));