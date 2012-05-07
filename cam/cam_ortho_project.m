function u = cam_ortho_project(X)
x = renormI(X);
v = renormI(x(1:3,:));
u = v(1:2,:);