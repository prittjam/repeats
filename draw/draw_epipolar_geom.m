function l = draw_epipolar_lines(ax1,ax2,u,F)
l = blkdiag(F',F)*u([4:6 1:3],:);

line_draw(ax1,l(1:3,:));
pt_draw(ax1,u(1:2,:));

line_draw(ax2,l(4:6,:));
pt_draw(ax2,u(4:5,:));