function H = eg_np_lsqnonlin(u, sample_set, cfg, varargin)
F0 = cfg.model_args{1};

x = lsqnonlin(@sw, extract(F0), [], [], ...
              optimset('Display', 'Off', ...
                       'Diagnostics', 'Off', ...
                       'MaxIter', 3), ...
              u(:,sample_set));

H = reshape([x 1],3,3);

function dx = sw(x,u)
H = reshape([x 1],3,3);
[dx2, dx] = hg_sampson_err(H,u);


function [F] = eg_np_lsqnonlin(u, inlying_set, varargin)


f0 = extract_parameters(F0);
f = lsqnonlin(@f_sampson_wrapper, f0, ...
              [], [], optimset('TolFun', ...
                               1e-2, 'Display', ...
                               'Off'), u(:,inlying_set));
F = make_F(f(1), f(2), ...
           f(3), f(4:end));

function e = f_sampson_wrapper(x, u)
F = make_F(x(1), x(2), x(3), x(4:end));
dx2 = eg_sampson_err(F, u);
e = dx2(:);

function x = extract_parameters(F)
[e1 e2] = extract_epipoles(F);
theta = -atan2(e2(2), e2(1));
Rz = make_Rz(theta);
tx = -dot(Rz(1,:),e2)+1;
f = e2(3);
H2 = calc_H2(f,theta,tx);
M = calc_compatible_hg(F);
H = H2*M;
H = H(2:3,1:3);

x = [[f theta tx]'; H(:)];

function [Rz] = make_Rz(phi)
Rz = [  cos(phi)  -sin(phi) 0; ...
        sin(phi)   cos(phi) 0; ...
        0          0        1];

function [H2] = calc_H2(f,theta,tx)
Tx = [1  0  tx; ...
      0  1  0; ...
      0  0  1];
K =  [ 1  0  0; ...
       0  1  0; ...
      -f  0  1];
Rz = make_Rz(theta);
H2 = K*Tx*Rz;

function [F] = make_F(f,theta,tx,h)
a = cos(theta);
b = sin(theta);
F = [-h(1)*f*a-h(2)*b   -h(3)*f*a-h(4)*b   -h(5)*f*a-h(6)*b; ...
     -h(2)*a+h(1)*f*b   -h(4)*a+h(3)*f*b   -h(6)*a+h(5)*f*b; ...
     -h(1)*(f*tx-1)     -h(3)*(f*tx-1)    -h(5)*(f*tx-1)];