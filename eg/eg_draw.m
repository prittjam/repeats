function l = eg_draw(im1,im2,F,u)
N = size(u,2);
l = zeros(6,N);
l([4:6 1:3],:) = blkdiag(F,F')*u;

hn = imdisp({im1,im2});

line_draw(hn(1),l(1:3,1:5:end));
pt_draw(hn(1),u(1:2,1:5:end));

line_draw(hn(2),l(4:6,1:5:end));
pt_draw(hn(2),u(4:5,1:5:end));