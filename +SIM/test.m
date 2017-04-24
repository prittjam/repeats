function [] = test()
[u,G,rows,cols,cam,X,P] = SIM.make_dr('ccd_sigma',0,'lambda',0);

figure;
hold on;
plot3(X(1,:),X(2,:),X(3,:),'b.');
%plot3(coa(1),coa(2),coa(3),'r.');
hold off;
CAM.draw(gca,P);
axis equal;
cameratoolbar;

figure;
hold on;
plot(u(1,:),u(2,:),'b.')
%plot(v(1,:),v(2,:),'k-');
%for k = 1:4:size(w,2)
%    plot([w(1,k:k+3) w(1,k)],[w(2,k:k+3) w(2,k)]);
%end
hold off;
axis ij;
axis equal;
axis(0.5+[0 cam.nx 0 cam.ny]);
