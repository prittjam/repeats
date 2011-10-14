function l = eg_draw_epilines(u,F,im1,im2)
l = blkdiag(F,F')*u;

hn = imdisp({im1,im2});

line_draw(hn(1),l(4:6,:));
pt_draw(hn(1),u(1:3,:));

line_draw(hn(2),l(1:3,:));
pt_draw(hn(2),u(4:6,:));
