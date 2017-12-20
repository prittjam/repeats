function [] = render(P,X,coa)
figure;
CAM.render_scene(P,X);

figure;
x = PT.renormI(P*X);
