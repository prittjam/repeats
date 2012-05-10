function [] = draw2d_wireframe(ax1,x1,edges)
axes(ax1);
hold on;
plot(reshape(x1(1,edges),2,[]), ...
     reshape(x1(2,edges),2,[]),'k');
hold off;