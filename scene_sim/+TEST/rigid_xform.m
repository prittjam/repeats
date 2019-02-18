[X,cspond,G,gtparams] = PLANE.make_cspond_set_Rt(10,'Reflect',true);
X4 = reshape(X,4,[]);
P = [1 0 0 0; 
     0 1 0 0; 
     0 0 0 1];
x0 = PT.renormI(P*X4);
x = reshape(x0,9,[]); 
params = HG.laf2xN_to_RtxN([x(:,cspond(1,:));x(:,cspond(2,:))]);
R = Rt.params_to_mtx(params);
y0 = PT.mtimesx(R,x(:,cspond(1,:)));

hold on;
LAF.draw(gca,x0);
LAF.draw(gca,y0,'LineStyle','--','Color','k','LineWidth',3);
hold off;

Rgt = Rt.params_to_mtx(gtparams);
gt = PT.mtimesx(Rgt,x(:,cspond(1,:)));

LAF.draw(gca,ygt,'LineStyle','--','Color','g');