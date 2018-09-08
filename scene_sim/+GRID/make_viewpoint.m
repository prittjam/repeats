%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
% Copyright (c) 2017 James Pritts
% 
function P = make_viewpoint(X,cam)
w = max(X(1,:))-min(X(1,:));
h = max(X(2,:))-min(X(2,:));

cam_dist = w/2/sin(cam.hfov/2);

muX = mean(X(1:3,:),2);

phi = rand(1,1)*2*pi;
theta = rand(1,1)*30*pi/180;

c = muX+[cam_dist*sin(theta)*cos(phi); ...
         cam_dist*sin(theta)*sin(phi); ...
         cam_dist*cos(theta)];
coa = [mvnrnd(muX(1:2),diag([(w/3)^2 (h/3)^2]))';0];
coa = [muX(1:2);0];


look_at = (coa-c)/norm(coa-c);
look_up = [0 1 0]'-dot([0 1 0]',look_at)*look_at;
look_down = -look_up/norm(look_up);
look_right = cross(look_down,look_at);

R = [look_right'; look_down'; look_at'];
P = cam.K*[R -R*c];

%GRID.render(P,X,coa);xsyxs
