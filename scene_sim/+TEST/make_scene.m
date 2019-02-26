function [xdn,G,cc] = make_scene()
cfg = struct('nx', 1000, ...
             'ny', 1000, ...
             'cc', [], ...
             'q', -4, ...
             'rigidxform', 'Rt', ...
             'numscenes', 1000, ...
             'ccdsigmalist', [0 0.1 0.5 1 2 5], ...
             'normqlist',-4);

if isempty(cfg.cc)
    cc = [cfg.nx/2+0.5; ...
          cfg.ny/2+0.5];
else
    cc = cfg.cc;
end    

f = 5*rand(1)+3;
cam = CAM.make_ccd(f,4.8,cfg.nx,cfg.ny);
P = PLANE.make_viewpoint(cam);

[X,~,G] = PLANE.make_group_same_Rt(10, ...
                                   'Reflect',0.0, ...
                                   'Orientation','Clockwise');
X4 = reshape(X,4,[]);
x = PT.renormI(P*X4);
q_gt = cfg.q/(sum(2*cc)^2);

xd = CAM.rd_div(reshape(x,3,[]),...
                cam.cc,q_gt);
xdn = reshape(xd,9,[]); 

keyboard;

figure;
PT.draw_groups(gca,xdn,G);
drawnow;