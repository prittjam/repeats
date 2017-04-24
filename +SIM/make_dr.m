function [pts,cam,gt] = make_dr(varargin)
cfg.ccd_sigma = 0.0;
cfg.lambda = 0.0;
cfg.nx = 1000;
cfg.ny = 1000;

cfg = cmp_argparse(cfg,varargin{:});

sp = SIM.random_scene_plane(); 
pattern = SIM.random_coplanar_pattern();
pts = pattern.make();

[K,cam] = CAM.make_ccd(4.15,4.8,cfg.nx,cfg.ny);

cam_dist = 1.5*sqrt(pattern.h^2+pattern.w^2)/2/sin(cam.hfov/2);

X = [pts(:).X];
muX = mean(X(1:3,:),2);

phi = rand(1,1)*1*pi;
theta = 45*pi/180;

c = muX+[cam_dist*sin(theta)*cos(phi); ...
         cam_dist*sin(theta)*sin(phi); ...
         cam_dist*cos(theta)];

coa = [mvnrnd(muX(1:2),diag([(pattern.h/3)^2 (pattern.w/3)^2]))';0];

look_at = (coa-c)/norm(coa-c);
look_up = [0 1 0]'-dot([0 1 0]',look_at)*look_at;
look_up = look_up/norm(look_up);
look_right = cross(look_at,look_up);

R = [look_right'; look_up'; look_at'];
cam.P = K*[R -R*c];

N = size(X,2);

u = PT.renormI(cam.P*X);

tmp = mat2cell(u,3,ones(1,N));
[pts(:).u] = tmp{:};

[linf,v] = calc_gt(pts,cam);

gt = struct('linf',linf, 'v',v, ...
            'lambda', cfg.lambda, ...
            'ccd_sigma', cfg.ccd_sigma);

