%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
% Copyright (c) 2017 James Pritts
% 
function [P,x] = make_viewpoint(cam,varargin)
cfg.phi = rand(1,1)*2*pi;
cfg.theta = rand(1,1)*45*pi/180;
cfg.w = 1;
cfg.h = 1;
cfg.coa = [];

cfg = cmp_argparse(cfg,varargin{:});

w = cfg.w;
h = cfg.h;

if isempty(cfg.coa)
    coa = transpose(mvnrnd([0 0 0],[(w/6)^2 (h/6)^2 0]));    
else
    coa = cfg.coa;
end

cam_dist = 1.5*w/2/tan(cam.hfov/2);

c = [cam_dist*sin(cfg.theta)*cos(cfg.phi); ...
     cam_dist*sin(cfg.theta)*sin(cfg.phi); ...
     cam_dist*cos(cfg.theta)];

look_at = (coa-c)/norm(coa-c);
look_up = [0 1 0]'-dot([0 1 0]',look_at)*look_at;
look_down = -look_up/norm(look_up);
look_right = cross(look_down,look_at);

R = [look_right'; look_down'; look_at'];
P = cam.K*[R -R*c];

X = [-w/2  w/2 w/2 -w/2 -w/2; ...
     -h/2 -h/2 h/2  h/2 -h/2; ...
        0    0   0    0    0; ...
        1    1   1    1    1];
x = PT.renormI(P*X);