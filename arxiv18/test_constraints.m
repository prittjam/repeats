function [] = test_constraints()
nx = 1000;
ny = 1000;
f = 5*rand(1)+3;
cam = CAM.make_ccd(f,4.8,nx,ny);
[P,xb] = PLANE.make_viewpoint(cam ,'w',10,'h',10);

X = PLANE.sample_cspond('laf22','Rt');
M = [10 0 0 0;0 10 0 0; 0 0 10 0; 0 0 0 1];
x = LAF.renormI(blkdiag(P,P,P)*blkdiag(M,M,M)*X);

figure;
plot(xb(1,:),xb(2,:),'b')
LAF.draw(gca,x);
axis ij;
axis equal;

gt = PLANE.make_Rt_gt(1,P,0,cam.cc,0);
l = gt.l/gt.l(3);

[~,si_fn] = make_closed_form_constraints();
[cartesian,polar] = make_change_of_scale_constraints();

sd = LAF.calc_scale(x);
mux = LAF.calc_mu(x);

for k = 1:size(x,2)
    s1(k) = si_fn(l(1),l(2),gt.q, ...
                    x(1,k),x(4,k),x(7,k),x(2,k),x(5,k),x(8,k));
    s2(k) = cartesian.si10_fn(l(1),l(2),sd(k),mux(1,k),mux(2,k));
    s3(k) = cartesian.si10_fn(l(1),l(2),sd(k),x(4,k),x(5,k));
end

H = eye(3);
H(3,:) = transpose(l);
xp = LAF.renormI(blkdiag(H,H,H)*x);

keyboard;

[H,rsc] = laf22_to_Hinf(x,[1 1 2 2]);
l2 = transpose(H(3,:));
l2 = l2/l2(3);

syms l1 l2 l3;
syms x y;
X = transpose([x y 1]);
HH = [ 1 0 0; 0 1 0; l1 l2 l3 ] ;
xp = HH*X;
xp = xp(1:2)/xp(3);
J = jacobian(xp, [x y]);
detJ = det(J);