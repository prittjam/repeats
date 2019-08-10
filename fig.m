function [] = fig()
cfg = struct('nx', 1000, ...
             'ny', 1000, ...
             'RigidXform', 't')
f = 5*rand(1)+3;
cam = CAM.make_ccd(f,4.8,cfg.nx,cfg.ny);
%                              'theta', pi/3, ...
[P,xb] = PLANE.make_viewpoint(cam, ...
                              'phi', 0, ...
                               'theta', -2*pi/5, ...
                               'coa', [0 0 0]', ...
                               'w',15,'h',15);
[P0,xb0] = PLANE.make_viewpoint(cam, ...
                               'phi', 0, ...
                               'theta', 0, ...
                                'coa', [0 0 0]', ...
                                'w',15,'h',15);

[X,cspond,idx,G] = ...
    PLANE.sample_cspond('2',9,9, ...
                        'RigidXform',cfg.RigidXform, ...
                        'reflect',0);

[X2,cspond2,G2,v] = ...
    PLANE.make_cspond_same_reflect_v(1);

idx2 = {3 4};

%[X2,cspond2,idx2,G2] = ...
%    PLANE.sample_cspond('2',9,9, ...
%                        'RigidXform',cfg.RigidXform, ...
%                        'reflect', 0.5);
%
X = [X X2];
cspond = [cspond cspond2];
idx = [idx idx2];
G = [G G2];

X4 = reshape(X,4,[]);

q_gt = -8/sum(2*cam.cc)^2;

x = reshape(PT.renormI(P*X4),9,[]);
xd = PT.rd_div(x,cam.cc,q_gt);
xb  = reshape(xb,3,[]);
xbd = PT.rd_div(reshape(xb,3,[]),cam.cc,q_gt);

x0 = reshape(PT.renormI(P0*X4),9,[]);
%x0d = PT.rd_div(x0,cam.cc,q_gt);
%x0bd = PT.rd_div(reshape(xb0,3,[]),cam.cc,q_gt);

v2 = PT.renormI(inv(P(1:3,[1 2 4])')*v);
l = inv(P(1:3,[1 2 4])')*[0 0 1]';

figure;
set(gcf,'color','w')
subplot(2,2,1);
axis equal;
axis ij;
hold on;
plot(xbd(1,:),xbd(2,:),'k-');

LAF.draw(gca,xd(:,1:2),'Color','b','LineStyle','--');
%LAF.draw(gca,xd(:,3:4),'Color','r','LineStyle','--');

hold on;
xd3 = reshape(xd,3,[]);
plot(xd3(1,[1 2 4 5]),xd3(2,[1 2 4 5]),'b.', 'MarkerSize', 10);
plot(xd3(1,[1:6]),xd3(2,[1:6]),'bo', 'MarkerSize', 5);
plot(xd3(1,[7 8 10 11]),xd3(2,[7 8 10 11]),'r.', 'MarkerSize', 10);

plot(xd3(1,[7 8]),xd3(2,[7 8]), 'Color', 'r', 'LineStyle','--');
plot(xd3(1,[10 11]),xd3(2,[10 11]), 'Color', 'r', 'LineStyle','--');

%LAF.draw(gca,xd(:,5:6),'Color','b');
c = LINE.rd_div(q_gt,cam.cc,l);
CONIC.draw_circle(gca,c,'Color','k');

cv = LINE.rd_div(q_gt,cam.cc, ...
                 inv(P(1:3,[1 2 4])')*v);
CONIC.draw_circle(gca,cv,'Color','r', ...
                  'LineStyle',':','LineWidth',1);


hold off;
xlim([0 1000]);
ylim([0 1000]);
axis off;

subplot(2,2,2);
axis equal;
axis ij;
hold on;
LAF.draw(gca,x(:,1:2),'Color','b','LineStyle','--');
%LAF.draw(gca,xd(:,3:4),'Color','r','LineStyle','--');

hold on;
x3 = reshape(x,3,[]);

plot(xb(1,:),xb(2,:),'k-');
plot(x3(1,[1 2 4 5]),x3(2,[1 2 4 5]),'b.', 'MarkerSize', 10);
plot(x3(1,[1:6]),x3(2,[1:6]),'bo', 'MarkerSize', 5);
plot(x3(1,[7 8 10 11]),x3(2,[7 8 10 11]),'r.', 'MarkerSize', 10);
plot(x3(1,[7 8]),x3(2,[7 8]), 'Color', 'r', 'LineStyle','--');
plot(x3(1,[10 11]),x3(2,[10 11]), 'Color', 'r', 'LineStyle','--');

LINE.draw_extents(gca,l,'Color','k');
LINE.draw_extents(gca,v2, ...
                  'Color','r','LineStyle',':');

hold off;
xlim([0 1000]);
ylim([0 1000]);
axis off;

subplot(2,2,4);
axis equal;
axis ij;
A = [1 0.5 0; 
     0.5 1 0; 
     0 0 1]
ylaf = blkdiag(A,A,A)*x0;
yb0 = A*xb0

hold on;
y3 = reshape(ylaf,3,[]);
plot(y3(1,[1 2 4 5]),y3(2,[1 2 4 5]),'b.', 'MarkerSize', 10);
plot(y3(1,[1:6]),y3(2,[1:6]),'bo', 'MarkerSize', 5);
plot(y3(1,[7 8 10 11]),y3(2,[7 8 10 11]),'r.', 'MarkerSize', 10);
plot(y3(1,[7 8]),y3(2,[7 8]), 'Color', 'r', 'LineStyle','--');
plot(y3(1,[10 11]),y3(2,[10 11]), 'Color', 'r', 'LineStyle','--');
plot(yb0(1,:),yb0(2,:),'k-');

LAF.draw(gca,ylaf(:,1:2),'Color','b','LineStyle','--');
LINE.draw_extents(gca,PT.renormI(inv(A*P0(:,[1 2 4]))'*v), ...
                  'Color', 'r', 'LineStyle', ':');
%LAF.draw(gca,ylaf(:,5:6),'Color','b');
hold off;
xlim([0 1000]);
ylim([0 1000]);
axis off;
axis tight;

subplot(2,2,3);
axis equal;
axis ij;

v3 = inv(P0(:,[1 2 4]))'*v;
v3n = v3(1:2)/norm(v3(1:2));
theta = atan2(v3n(2),v3n(1));
R = [cos(theta) sin(theta) 0;
    -sin(theta) cos(theta) 0;
      0           0        1];
hold on;
Rxb0 = R*xb0;

plot(Rxb0(1,:),Rxb0(2,:),'k-');
rx0 = blkdiag(R,R,R)*x0;

z3 = reshape(rx0,3,[]);
plot(z3(1,[1 2 4 5]),z3(2,[1 2 4 5]), ...
     'b.', 'MarkerSize', 10);
plot(z3(1,[1:6]),z3(2,[1:6]), ...
     'bo', 'MarkerSize', 5);
plot(z3(1,[7 8 10 11]),z3(2,[7 8 10 11]), ...
     'r.', 'MarkerSize', 10);
plot(z3(1,[7 8]),z3(2,[7 8]), ...
     'Color', 'r', 'LineStyle','--');
plot(z3(1,[10 11]),z3(2,[10 11]), ...
     'Color', 'r', 'LineStyle','--');

LAF.draw(gca,rx0(:,1:2), ...
         'Color','b','LineStyle','--');
LINE.draw_extents(gca,R*v3, ...
                  'LineStyle', ':', ...
                  'Color', 'r');
%LAF.draw(gca,rx0(:,3:4),'Color','r');
hold off;
axis off;
axis tight;

kkk = 3;