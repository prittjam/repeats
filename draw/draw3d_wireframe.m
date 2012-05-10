function [] = draw3d_wireframe(ax1,x1,edges)
axes(ax1);
hold on;
plot3(reshape(x1(1,edges),2,[]), ...
      reshape(x1(2,edges),2,[]), ...
      reshape(x1(3,edges),2,[]),'k');
hold off;