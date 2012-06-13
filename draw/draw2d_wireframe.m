function draw2d_wireframe(ax1,u,edges)
un = renormI(u);
axes(ax1);
hold on;
plot(reshape(un(1,edges),2,[]), ...
     reshape(un(2,edges),2,[]),'k');
hold off;