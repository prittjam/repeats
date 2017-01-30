function v = apply_rigid_xform(u,theta,t)
c = cos(theta);
s = sin(theta);
v = u;
v(1:2,:) = [ c.*u(1,:)-s.*u(2,:); ...
             s.*u(1,:)+c.*u(2,:)]+t;
