function [] = draw3d_wireframe(ax1,x1,edges)
axes(ax1);
hold on;
plot(reshape(x1(1,edges),2,[]),reshape(x1(2,edges),2,[]),'y');
plot(x1(1,:),x1(2,:),'b.');
hold off;