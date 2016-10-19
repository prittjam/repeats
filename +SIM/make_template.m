function [u2,x2] = make_template(num_pts,w2,h2)
u = [rand(2,num_pts); ...
     ones(1,num_pts)];
v = cross(u(:,1:3:end)-u(:,2:3:end), ... 
          u(:,3:3:end)-u(:,2:3:end));
s1 = repmat(v(3,:) < 0,3,1);

ib = find(s1);
tmp = u(:,ib(1:3:end));
u(:,ib(1:3:end)) = u(:,ib(3:3:end));
u(:,ib(3:3:end)) = tmp;

M = [[w2 0; 0 h2] [-w2/2 -h2/2]'; ...
      0 0 1]*[1 0 0; 0 -1 1; 0 0 1];
u2 = M*u;

x = [-0.2 1.2 1.2 -0.2; -0.2 -0.2 1.2 1.2; 1 1 1 1];
x2 = M*x;