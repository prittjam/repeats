function [P nx ny q cc sigma] = make_cam(g,w,h,dd,varargin)
cfg.ccd_sigma = 0.0;
cfg.lens_distortion = 0.0;

[cfg,~] = cmp_argparse(cfg,varargin);

params = [ 2*dd 3*dd; ...       % distance from camera to facade [m]    
           35*10^-3 70*10^-3; ... % focal length full frame 35mm
          -0.8 0; ... % lens distortion
           0 1];   % CCD noise noise
nparams = size(params,1);
rv = params(:,1)+(params(:,2)-params(:,1)).*rand(nparams,1);

cam_dist = rv(1);
ef = rv(2);

if isempty(cfg.lens_distortion)
    q = rv(3);
else
    q = 0;
end

if isempty(cfg.ccd_sigma)
    sigma = rv(4);
else
    sigma = cfg.ccd_sigma;
end

[K,nx,ny,ccd_sz,f] = CAM.make_small_ccd(ef);

cv = [1/6     0; ...
      0      1/6];

while true
    a = mvnrnd([0 0]',cv)';
    if norm(a,'inf') < 1
        o4 = [w/2*a(1) h/2*a(2) 1]';
        break;
    end
end 

theta = rand(1,1)*pi+pi;
phi = rand(1,1)*pi/2;

r = [cam_dist*sin(phi)*cos(theta); ...
     cam_dist*sin(phi)*sin(theta); ...
     cam_dist*cos(phi)];
g = g/norm(g);
z3 = -r/norm(r,2);
x3 = cross(g,z3);
y3 = cross(z3,x3);

B1 = [eye(3,3) o4; [0 0 0 1]];
B2 = [ [x3 y3 z3] r; 0 0 0 1];
M2 = inv(B1*B2);

P = K*M2(1:3,:);

cc = [nx+1 ny+1]/2;