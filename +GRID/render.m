function [] = render(P,X,coa)
figure;
CAM.render_scene(P,X);
hold on;
plot3(coa(1),coa(2),coa(3),'ko');
hold off;

figure;
x = PT.renormI(P*X);
xcoa = PT.renormI(P*[coa;1]);
plot(x(1,:),x(2,:),'k.');
hold on;
plot(xcoa(1,:),xcoa(2,:),'g.');
hold off;
