function [] = draw3d_wireframe(ax1,X,edges)
axes(ax1);

hold on;
plot3(reshape(X(1,edges),2,[]), ...
      reshape(X(2,edges),2,[]), ...
      reshape(X(3,edges),2,[]),'k');
hold off;