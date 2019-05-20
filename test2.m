cfg  = struct('nx',1000, ...
              'ny',100);
f = 5*rand(1)+3;
cam = CAM.make_ccd(f,4.8,cfg.nx,cfg.ny);
P0 = cam.K*[eye(3) zeros(3,1)];
P1 = PLANE.make_viewpoint(cam);
figure;
hold on;
CAM.draw(gca,P0);
CAM.draw(gca,P1);
hold off;

cameratoolbar;