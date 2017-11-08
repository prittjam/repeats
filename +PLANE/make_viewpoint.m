% Copyright (c) 2017 James Pritts
% 
function P = make_viewpoint(cam,w,h)
cam_dist = 1.5*w/2/tan(cam.hfov/2);

phi = rand(1,1)*2*pi;
theta = rand(1,1)*45*pi/180;

c = [cam_dist*sin(theta)*cos(phi); ...
     cam_dist*sin(theta)*sin(phi); ...
     cam_dist*cos(theta)];
coa = transpose(mvnrnd([0 0 0],[(w/6)^2 (h/6)^2 0]));

look_at = (coa-c)/norm(coa-c);
look_up = [0 1 0]'-dot([0 1 0]',look_at)*look_at;
look_down = -look_up/norm(look_up);
look_right = cross(look_down,look_at);

R = [look_right'; look_down'; look_at'];
P = cam.K*[R -R*c];
