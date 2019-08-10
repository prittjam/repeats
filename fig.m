function [] = fig()
cfg = struct('nx', 1000, ...
             'ny', 1000, ...
             'RigidXform', 'Rt')
f = 5*rand(1)+3;
cam = CAM.make_ccd(f,4.8,cfg.nx,cfg.ny);
[P,xb] = PLANE.make_viewpoint(cam, ...
                               'phi', 0, ...
                               'theta', -pi/2.5);
[P0,xb0] = PLANE.make_viewpoint(cam, ...
                               'phi', 0, ...
                               'theta', 0);

[X,cspond,idx,G] = ...
    PLANE.sample_cspond('222',9,9,'RigidXform',cfg.RigidXform);
X4 = reshape(X,4,[]);

q_gt = -8/sum(2*cam.cc)^2;

x = reshape(PT.renormI(P*X4),9,[]);
xd = PT.rd_div(x,cam.cc,q_gt);
xb  = reshape(xb,3,[]);
xbd = CAM.rd_div(reshape(xb,3,[]),cam.cc,q_gt);

x0 = reshape(PT.renormI(P0*X4),9,[]);
x0d = PT.rd_div(x0,cam.cc,q_gt);
x0bd = CAM.rd_div(reshape(xb0,3,[]),cam.cc,q_gt);

l = inv(P(1:3,1:3)')*[0 0 1]';


figure;
axis equal;
axis ij;
hold on;
plot(xbd(1,:),xbd(2,:),'k-');
LAF.draw_groups(gca,xd,G);
c = LINE.rd_div(q_gt,cam.cc,l)
CONIC.draw_circle(gca,c,'Color','k')
hold off;
xlim([0 1000]);
ylim([0 1000]);

figure;
axis equal;
axis ij;
hold on;
plot(xb(1,:),xb(2,:),'k-');
LAF.draw_groups(gca,x,G);
LINE.draw(gca,l,'Color','k');
hold off;
xlim([0 1000]);
ylim([0 1000]);

figure;
axis equal;
axis ij;
hold on;
plot(x0(1,:),x0(2,:),'k-');
LAF.draw(gca,);
hold off;