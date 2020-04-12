function [cam, x] = make_viewpoint(cam,varargin)
    cfg = struct('w', 10, 'h', 10,...
                'R', NaN, 'c', NaN, ...
                'phi', rand(1,1)*2*pi, ...
                'theta', rand(1,1)*45*pi/180, ...
                'coa', []);
    cfg = cmp_argparse(cfg,varargin{:});

    w = cfg.w;
    h = cfg.h;

    if isnan(cfg.c)
        if isempty(cfg.coa)
            coa = transpose(mvnrnd([0 0 0],[(w/6)^2 (h/6)^2 0]));    
        else
            coa = cfg.coa;
        end

        cam_dist = 1.5*w/2/tan(cam.hfov/2);

        c = [cam_dist*sin(cfg.theta)*cos(cfg.phi); ...
            cam_dist*sin(cfg.theta)*sin(cfg.phi); ...
            cam_dist*cos(cfg.theta)];
    else
        c = cfg.c;
    end

    if isnan(cfg.R)
        look_at = (coa-c)/norm(coa-c);
        look_up = [0 1 0]'-dot([0 1 0]',look_at)*look_at;
        look_down = -look_up/norm(look_up);
        look_right = cross(look_down,look_at);
        cam.R = [look_right'; look_down'; look_at'];
    else
        cam.R = cfg.R;
    end

    cam.c = -cam.R * c;
    
    cam.P34 = cam.K * [cam.R cam.c];
    cam.P = cam.P34(:, [1 2 4]);
    cam.l = cam.P' \ [0 0 1]';

    X = [-w/2  w/2 w/2 -w/2 -w/2; ...
        -h/2 -h/2 h/2  h/2 -h/2; ...
            0    0   0    0    0; ...
            1    1   1    1    1];

    x = PT.renormI(cam.P34 * X);
end