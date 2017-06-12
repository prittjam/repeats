function [udn,X,cam,gt] = make_imaged_grid(varargin)
cfg = struct('nx', 1000, ...
             'ny', 1000, ...
             'lambda', -0.3, ...
             'ccd_noise', 0.1);

cfg = cmp_argparse(cfg,varargin{:});
cam = CAM.make_ccd(4.15,4.8,cfg.nx,cfg.ny);
pattern = SIM.random_coplanar_pattern();
scene = pattern.make();

P = SIM.make_grid_viewpoint(scene,cam);
cam.P = P;
X = [scene(:).X];
u = PT.renormI(P*X);


ud = CAM.rd_div(u,cam.cc,cfg.lambda);
udn = CAM.add_noise(ud,cfg.ccd_noise);
scene_num = 1;
gt = SIM.make_grid_gt(scene,scene_num, ...
                      cam,P, ...
                      cfg.lambda,cfg.ccd_noise);
