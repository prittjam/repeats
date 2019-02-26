[X,cspond,G,gtparams] = PLANE.make_group_same_Rt(10,'Reflect',1);
X4 = reshape(X,4,[]);
P = [1 0 0 0; 
     0 1 0 0; 
     0 0 0 1];
x0 = PT.renormI(P*X4);
x = reshape(x0,9,[]); 
params = HG.laf2xN_to_RtxN([x(:,cspond(1,:));x(:,cspond(2,:))]);
R = Rt.params_to_mtx(params);
y2 = PT.mtimesx(R,x(:,cspond(1,:)));
y1 = PT.mtimesx(multinv(R),x(:,cspond(2,:)))

err1 = y1-x(:,cspond(1,:));
err2 = y2-x(:,cspond(2,:));

d2 = sum([err1.^2;err2.^2]);

keyboard;





Rgt = Rt.params_to_mtx(gtparams);
gt = PT.mtimesx(Rgt,x(:,cspond(1,:)));

LAF.draw(gca,ygt,'LineStyle','--','Color','g');

