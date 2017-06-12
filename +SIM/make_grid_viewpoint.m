% Copyright (c) 2017 James Pritts
% 
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
look_up = [0 0 1]'-dot([0 0 1]',look_at)*look_at;
look_down = -look_up/norm(look_up);
look_right = cross(look_down,look_at);

R = [look_right'; look_down'; look_at'];
P = cam.K*[R -R*c];

%keyboard;
%figure;
%hold on;
%plot3(X(1,:),X(2,:),X(3,:),'b.');
%hold on;line([c(1) c(1)+20*look_right(1)], [c(2) c(2)+20*look_right(2)] ,[c(3) c(3)+20*look_right(3)],'color','r');hold off;
%hold on;line([c(1) c(1)+20*look_at(1)], [c(2) c(2)+20*look_at(2)] ,[c(3) c(3)+20*look_at(3)],'color','b');hold off;
%%)],'color','g');hold off;
%hold on;line([c(1) c(1)+20*look_down(1)], [c(2) c(2)+20*look_down(2)] ,[c(3) c(3)+20*look_down(3)],'color','g');hold off;
%cameratoolbar; 
%axis equal
%figure;
%plot(u(1,:),u(2,:),'b.');
