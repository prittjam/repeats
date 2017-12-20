function s1 = is_right_handed(u)
u = reshape(u,3,[]);
v = cross(u(:,1:3:end)-u(:,2:3:end), ... 
          u(:,3:3:end)-u(:,2:3:end));
s1 = v(3,:) > 0;
