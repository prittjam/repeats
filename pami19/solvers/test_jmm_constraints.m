clear all;
repeats_init();
f = 5*rand(1)+3;
cam = CAM.make_ccd(f,4.8,1000,1000);
q = -4/(sum(2*cam.cc)^2);
P = PLANE.make_viewpoint(cam);
gt = PLANE.make_Rt_gt(1,P,q,cam.cc,0);

[X,cspond,idx,G] = PLANE.sample_cspond('laf2','RigidXform','t');

x = PT.renormI(P*reshape(X,4,[]));
xd = CAM.rd_div(reshape(x,3,[]),cam.cc,q);

A = [1 0 -cam.cc(1); ...
     0 1 -cam.cc(2); ...
     0 0  1];
xdc = A*xd;
l = inv(A)'*gt.l;
l = l/l(3);

%figure;
%LAF.draw(gca,xd_laf);
%axis equal;
%axis ij;
%
[Eqs,Jfn] =  make_jmm_constraints();
J = Jfn(l(1),l(2),q, ...
        xdc(1,1),xdc(1,2),xdc(1,4),xdc(1,5), ...
        xdc(2,1),xdc(2,2),xdc(2,4),xdc(2,5));

assert(J < 1e-11,'Constraints NOT satisfied!');
