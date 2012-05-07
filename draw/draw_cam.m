function [] = draw_cam(ax1,P)
[K R C] = Q2KRC(P);
Beta = R';
draw_csystem(ax1,Beta,C,'b','a');

