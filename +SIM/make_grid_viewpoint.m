function P = make_grid_viewpoint(pts,cam)
X = [pts(:).X];
w = max(X(1,:))-min(X(1,:));
h = max(X(2,:))-min(X(2,:));

cam_dist = 1.5*sqrt(h^2+w^2)/2/sin(cam.hfov/2);

muX = mean(X(1:3,:),2);

phi = rand(1,1)*2*pi;
theta = 60*pi/180;

c = muX+[cam_dist*sin(theta)*cos(phi); ...
         cam_dist*sin(theta)*sin(phi); ...
         cam_dist*cos(theta)];

coa = [mvnrnd(muX(1:2),diag([(w/3)^2 (h/3)^2]))';0];

look_at = (coa-c)/norm(coa-c);
look_up = [0 1 0]'-dot([0 1 0]',look_at)*look_at;
look_up = look_up/norm(look_up);
look_right = cross(look_at,look_up);

R = [look_right'; look_up'; look_at'];
P = cam.K*[R -R*c];
