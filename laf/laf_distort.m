function [x1d,y2d] = laf_distort(u,dist_xform)
[wx,wy] = draw2d_make_piecewise_linear_lafs(u); 
ud = tformfwd(dist_xform, [wx(:) wy(:)]);
x1d = reshape(ud(:,1),size(wx));
y1d = reshape(ud(:,2),size(wy));